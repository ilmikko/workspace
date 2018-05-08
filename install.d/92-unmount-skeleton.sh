#
# Clean up the skeleton files
#

# Unmount the device
oos_umount $OOS_INSTALL_DEVICE;

# Sync the device (useful with USB devices)
sync;

# Clean up the mount folder
rmdir $OOS_MOUNT_FOLDER;

. $@;
