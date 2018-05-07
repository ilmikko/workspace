oos_wipe() {
	# wipefs -a $1;
	echo wipefs -a $1;
}

oos_partition() {
	# First, create the boot partition.
	echo "Partitioning disk...";
}

# Wipe the device
oos_wipe $OOS_INSTALL_DEVICE;

# Partition the device
oos_partition $OOS_INSTALL_DEVICE;

# Make the filesystems
#oos_create_fs $OOS_INSTALL_DEVICE;

# Mount the partitions, create the directory tree
#oos_mount $OOS_INSTALL_DEVICE;

