# 1. Linux
# This installs a barebone linux distribution. As we have a working internet connection, we can get the most of it done here.

# requirements: wipefs

oos_wipe() {
	# wipefs -a $@;
	echo wipefs -a $@;
}

oos_partition() {
	# First, create the boot partition.
	echo "Partitioning disk...";
}

log "Installing linux on $OOS_INSTALL_DEVICE...";

# FAILSAFE: Do NOT use /dev/sda or the current root device.
# This is only to save my butt when debugging the program.

if [ $OOS_INSTALL_DEVICE = '/dev/sda' ]; then
	abort "You were just about to wipe your main drive.";
	exit 5;
fi

# Wipe the device
oos_wipe $OOS_INSTALL_DEVICE;

# Partition the device
oos_partition $OOS_INSTALL_DEVICE;

# Make the filesystems
#oos_create_fs $OOS_INSTALL_DEVICE;

# Mount the partitions, create the directory tree
#oos_mount $OOS_INSTALL_DEVICE;
