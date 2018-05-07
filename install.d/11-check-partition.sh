#
# 0.8.1. Partition check
# Check that the disk has enough space for the partitions, and the
# partitions make sense (e.g. percentages sum up to 100%)
#

# Input: a device /dev/* of which space to check.
get_available_space() {
	#parted "$1" unit B print 2>/dev/null | awk '/\/dev\/\w+:/ { gsub("B$","",$3); print $3; }';
	fdisk -l "$1" | awk '/\/dev\/.*:/ { print $5 }';
}

get_root_partition() {
	mount | grep 'on / ' | awk '{ print $1 }';
}

pretty_print_partitions() {
	combined=$1;
	echo "Partition List:";
	for (( i=0; i<${#combined[@]}; i++ )) do
		split=(${combined[$i]//:/ });
		
		name=${split[0]};
		bytes=$(from_bytes ${split[1]});
		mount=${split[2]};

		printf "%-12s%-10s%10s\n" $name $mount $bytes;
	done
}

log "Checking partitioning settings...";

# Warn if we are writing on /dev/sda (or whichever is the root partition)
if [[ "$(get_root_partition)" == "$OOS_INSTALL_DEVICE"* ]]; then
	confirm "$OOS_INSTALL_DEVICE seems to be the root device. Are you sure you want to overwrite the current system" || abort "Installation cancelled.";
fi

# There must be enough space on the disk
available_space=$(get_available_space "$OOS_INSTALL_DEVICE");
available_space_human=$(from_bytes $available_space);

log "There is $available_space_human available on $OOS_INSTALL_DEVICE";

# Take absolute sizes first, check that there is space available
partitions=$OOS_PARTITION_LIST;

echo ${OOS_PARTITION_LIST[@]}

join_by() {
	local IFS="$1"; shift; echo "$*";
}

is_percentage() {
	[[ $1 == *\% ]];
}

# Split the array into two (absolutes and relatives) and deal with those.
absolutes=($(printf "%s\n" ${partitions[@]} | awk -F':' '{ size=$2; if (sub("%$","",size)==0) print $0 }'));
relatives=($(printf "%s\n" ${partitions[@]} | awk -F':' '{ size=$2; if (sub("%$","",size)!=0) print $0 }'));

# Convert all absolute sizes to bytes
for (( i=0; i<${#absolutes[@]}; i++ )) do
	# Split into array by :
	item=(${absolutes[$i]//:/ })

	size=${item[1]};
	debug "Item size: ${item[1]}";

	# update item size
	item[1]=$(to_bytes $size);

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
	abort "The disk needs at least $used_space_human for the installation partitions.\nThere is only $available_space_human available on $OOS_INSTALL_DEVICE.\nPlease either resize your partition preferences or choose a different install device.";
fi

# Check that the percentages add up to 100%
percentage_sum=$(printf "%s\n" "${relatives[@]}" | awk -F':' '{ total += $2; } END { print total; }');
debug "Percentage sum: $percentage_sum";

# TODO: Convert the percentages to percentages between 0%..100%?
if [ ! -z "$percentage_sum" ] && [ "$percentage_sum" != 100 ]; then
	abort "The partition percentages do not sum up to 100%%.\nThey sum up to $percentage_sum%%.\nPlease check your configuration.";
fi

# Then, if $remaining_space > 0, convert the percentages to absolute values.
for (( i=0; i<${#relatives[@]}; i++ )) do
	# Split into array by :
	item=(${relatives[$i]//:/ })

	size=${item[1]};
	echo "Item size: ${item[1]}";

	# update item size
	item[1]=$(echo $size $remaining_space | awk -f awk/percentage.awk);

	# update the partition string
	relatives[$i]=$(join_by ':' ${item[@]});
done

# TODO: Pretty print the table / re-join the arrays
combined=("${absolutes[@]}" "${relatives[@]}");
pretty_print_partitions $combined;
. $@;
