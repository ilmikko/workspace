#
# Clean up the skeleton files
#

# Unmount the device
oos_umount $OOS_INSTALL_DEVICE;

# Clean up the mount folder
rmdir $OOS_MOUNT_FOLDER;

. $@;
