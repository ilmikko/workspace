#
# 0.8.1. Partition check
# Check that the disk has enough space for the partitions, and the
# partitions make sense (e.g. percentages sum up to 100%)
#

log "Checking partitioning settings...";

partitions=($OOS_PARTITION_LIST);

join_by() {
	local IFS="$1"; shift; echo "$*";
}

is_percentage() {
	# TODO: Make this work on POSIX
	[[ $1 == *\% ]];
}

# Check that partition table is defined.
[ -z "$OOS_PARTITION_DISK_LABEL" ] && abort "No partition table type defined! (OOS_PARTITION_DISK_LABEL)";

# Check that partition table is supported
oos_partlabel_supported $OOS_PARTITION_DISK_LABEL || abort "Partition disk label $OOS_PARTITION_DISK_LABEL is not supported! (OOS_PARTITION_DISK_LABEL)";

# Check that the partitions that the user wants are sane.
for (( i=0; i<${#partitions[@]}; i++ )) do
	split=(${partitions[$i]//:/ });

	name=${split[0]};
	bytes=${split[1]};
	mount=${split[2]};
	fs_type=${split[3]};

	# mount and name can be empty, in which case they are ignored
	if [ -z "$bytes" ] || [ -z "$fs_type" ]; then
		[ -z "$bytes" ] && abort "Partition ${partitions[$i]} has an empty bytes field!";
		[ -z "$fs_type" ] && abort "Partition ${partitions[$i]} has an empty filesystem field!";
	fi

	# check if file system is supported
	oos_filesystem_supported $fs_type || abort "Filesystem not supported: $fs_type";
done

# Input: a device /dev/* of which space to check.
get_available_space() {
	#parted "$1" unit B print 2>/dev/null | awk '/\/dev\/\w+:/ { gsub("B$","",$3); print $3; }';
	fdisk -l "$1" | awk '/\/dev\/.*:/ { print $5 }';
}

get_current_root_partition() {
	mount | grep 'on / ' | awk '{ print $1 }';
}

pretty_print_partitions() {
	combined=($@);
	echo "Partition List:";
	for (( i=0; i<${#combined[@]}; i++ )) do
		split=( ${combined[$i]//:/ } );
		
		name=${split[0]};
		bytes=$(from_bytes ${split[1]});
		mount=${split[2]};

		printf "%-12s%-10s%10s\n" $name $mount $bytes;
	done
}

# Warn if we are writing on /dev/sda (or whichever is the root partition)
# TODO: Make this work on POSIX
if [[ "$(get_current_root_partition)" == "$OOS_INSTALL_DEVICE"* ]]; then
	confirm "$OOS_INSTALL_DEVICE seems to be the root device. Are you sure you want to overwrite the current system" || abort "Installation cancelled.";
fi

# Check if partition is mounted; unmount it if this is the case.
oos_umount() {
	# TODO: Do this faster, and only start warning if it seems like a disk is actually busy (rather than a hierarchical problem)

	# Unmount swap partitions
	mounted_swap=($(swapon -s | grep "$1" | awk '{ print $1 }'));
	mounted_swap="${mounted_swap[@]}";
	if ! [ -z "$mounted_swap" ]; then
		log "Unmounting swap $mounted_swap...";
		swapoff $mounted_swap;
	fi
	
	# We need to unmount every subpartition this disk has.
	# e.g. /dev/sdb -> unmount /dev/sdb1, /dev/sdb2, ...
	# Because we can have multiple subpartitions inside each other, we need to mount the ones we can first, and loop through until we've unmounted everything.
	# This is sort of a hackish solution to do so.
	while true; do
		mounted_partitions=($(mount -l | grep "$1" | awk '{ print $1 }'));
		mounted_partitions="${mounted_partitions[@]}";

		# If we have no mounted partitions, break
		[ -z "$mounted_partitions" ] && break;

		echo Unmounting $mounted_partitions...;
		# Try to unmount all, some might fail and require another shot.
		umount $mounted_partitions && break;

		warning "Failed to unmount $mounted_partitions, trying again...";
		sleep 1;
	done
}

log "Checking $OOS_INSTALL_DEVICE mount status...";
# Unmount the device
oos_umount $OOS_INSTALL_DEVICE;

# There must be enough space on the disk
available_space=$(get_available_space "$OOS_INSTALL_DEVICE");
available_space_human=$(from_bytes $available_space);

log "There is $available_space_human available on $OOS_INSTALL_DEVICE";

# Take absolute sizes first, check that there is space available

# Split the array into two (absolutes and relatives) and deal with those.
absolutes=($(printf "%s\n" ${partitions[@]} | awk -F':' '{ size=$2; if (sub("%$","",size)==0) print $0 }'));
relatives=($(printf "%s\n" ${partitions[@]} | awk -F':' '{ size=$2; if (sub("%$","",size)!=0) print $0 }'));

# Convert all absolute sizes to bytes
for (( i=0; i<${#absolutes[@]}; i++ )) do
	# Split into array by :
	item=(${absolutes[$i]//:/ })

	size=${item[1]};
	debug "Item size: $size";

	bytes=$(to_bytes $size);

	# Check that the item size is sane
	[ -z "$bytes" ] || [ $bytes -lt 1 ] && abort "Invalid byte size: $size -> $bytes"B;

	# update item size
	item[1]=$bytes;

	# update the partition string
	# https://stackoverflow.com/questions/1527049/join-elements-of-an-array
	# "That said, this still seems to work… So, like most things with Bash, I'll pretend like I understand it and get on with my life." - David Wolever, Oct 6 '09 at 20:06
	absolutes[$i]=$(join_by ':' ${item[@]});
done

used_space=$(printf "%s\n" "${absolutes[@]}" | awk -F':' '{ used_space += $2 } END { print used_space }');
used_space_human="$(from_bytes $used_space)";

debug "Used space: $used_space";
debug "That is: $used_space_human";

remaining_space=$((available_space-used_space));
remaining_space_human="$(from_bytes $remaining_space)";
debug "This leaves $remaining_space for relative percentages.";
debug "That is: $remaining_space_human";

# If $remaining_space <= 0, (or ridiculously small), abort saying the disk needs more space for the partitions.
if [ "$remaining_space" -le "0" ]; then
	abort "The disk needs at least $used_space_human for the installation partitions." "There is only $available_space_human available on $OOS_INSTALL_DEVICE." "Please either resize your partition preferences or choose a different install device.";
fi

# Check that the percentages add up to 100%
percentage_sum=$(printf "%s\n" "${relatives[@]}" | awk -F':' '{ total += $2; } END { print total; }');
debug "Percentage sum: $percentage_sum";

# TODO: Convert the percentages to percentages between 0%..100%?
if [ ! -z "$percentage_sum" ] && [ "$percentage_sum" != 100 ]; then
	abort "The relative partition percentages do not sum up to 100%." "They sum up to $percentage_sum%." "Please check your configuration.";
fi

# Then, if $remaining_space > 0, convert the percentages to absolute values.
for (( i=0; i<${#relatives[@]}; i++ )) do
	# Split into array by :
	item=(${relatives[$i]//:/ })

	size=${item[1]};
	echo "Item size: ${item[1]}";

	# update item size
	item[1]=$(from_percentage $size $remaining_space);

	# update the partition string
	relatives[$i]=$(join_by ':' ${item[@]});
done

OOS_PARTITIONS=("${absolutes[@]}" "${relatives[@]}");
pretty_print_partitions ${OOS_PARTITIONS[@]};

. $@;
