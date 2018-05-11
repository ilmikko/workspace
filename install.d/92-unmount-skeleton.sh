#
# Clean up the skeleton files
#

# Unmount the device when finished
[ "$OOS_UNMOUNT_AFTER_INSTALL" = 1 ] && oos_umount $OOS_INSTALL_DEVICE;

# Sync the device (useful with USB devices)
log "Synchronizing cached writes...";
sync;

# Clean up the mount folder if it was not provided already
[ -z "$OOS_MOUNT_FOLDER" ] && rmdir $OOS_ROOT_FOLDER;

. $@;
