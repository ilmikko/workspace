oos_umount() {
	# We need to unmount every subpartition this disk has.
	# e.g. /dev/sdb -> unmount /dev/sdb1, /dev/sdb2, ...
	mounted_partitions=$(mount -l | grep '/dev/sdb' | awk '{ print $1 }');
	for (( i=0; i<${#mounted_partitions[@]}; i++ )) do
		part=${mounted_partitions[$i]};
		echo "Unmounting $part...";
		for (( h=0; h<5; h++ )) do
			umount $part && break;
			echo "Failed to unmount $part, trying again...";
			sleep 1;
		done
	done
}

oos_wipe() {
	# wipefs -a $1;
	echo wipefs -a $1;
}

oos_partition() {
	# First, create the boot partition.
	echo "Partitioning disk...";
}

# Unmount the device
oos_umount $OOS_INSTALL_DEVICE;

# Wipe the device
oos_wipe $OOS_INSTALL_DEVICE;

# Partition the device
oos_partition $OOS_INSTALL_DEVICE;

# Make the filesystems
#oos_create_fs $OOS_INSTALL_DEVICE;

# Mount the partitions, create the directory tree
#oos_mount $OOS_INSTALL_DEVICE;

