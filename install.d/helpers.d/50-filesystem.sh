oos_filesystem_supported() {
	case $1 in
		[Ee][Xx][Tt][234] | [Ff][Aa][Tt]32 | [Ss][Ww][Aa][Pp])
			true && return;
			;;
		*)
			false || return;
			;;
	esac
}

oos_partlabel_supported() {
	case $1 in
		[Gg][Pp][Tt] | [Dd][Oo][Ss] | [Mm][Bb][Rr] | [Ss][Uu][Nn] | [Ss][Gg][Ii] | [Ii][Rr][Ii][Xx])
			true && return;
			;;
		*)
			false || return;
			;;
	esac
}

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

# Input: a device /dev/* of which space to check.
get_available_space() {
	#parted "$1" unit B print 2>/dev/null | awk '/\/dev\/\w+:/ { gsub("B$","",$3); print $3; }';
	fdisk -l "$1" | awk '/\/dev\/.*:/ { print $5 }';
}

get_current_root_partition() {
	mount | grep 'on / ' | awk '{ print $1 }';
}

. $@;
