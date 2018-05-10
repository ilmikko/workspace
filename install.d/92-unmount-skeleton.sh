#
# Clean up the skeleton files
#

# Unmount the device
oos_umount $OOS_INSTALL_DEVICE;

# Sync the device (useful with USB devices)
log Synchronizing cached writes...;
sync;

# Clean up the mount folder
rmdir $OOS_ROOT_FOLDER;

. $@;
