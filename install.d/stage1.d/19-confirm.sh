# 0.9. Confirm
# Final confirmation of the installation, after this the install script will take over.
# This should be verbose enough to show everything that was configured, and this script is also
# responsible for storing the config file for the later installation stages.

log;
log "================================================================================";
log "             Please make sure the following information is correct.";
log "================================================================================";
log;
log "Installation device: $OOS_INSTALL_DEVICE";
log "Installation packages: $OOS_INSTALL_PACKAGES $OOS_DEFAULT_PACKAGES $OOS_ADDITIONAL_PACKAGES";
log "Installation name: $OOS_INSTALL_NAME";
log;
log "Partitions:";
pretty_print_partitions ${OOS_PARTITIONS[@]};
log;
log "You are about to install a new linux workspace on $OOS_INSTALL_DEVICE.";
log "Please type in uppercase YES to begin the installation process.";

if [ "$OOS_FASTTRACK" != "1" ]; then
	read -p '> ' confirmation;
else
	confirmation="YES";
fi

if [ "$confirmation" = "YES" ]; then
	log "Starting installation... you might want to grab a cup of tea now.";
	# Move to stage 2

	# Write the installation configuration file for the next stages, or to fast track if it fails
	echo _OOS_INSTALL_DEVICE=$OOS_INSTALL_DEVICE > $OOS_INSTALL_CONF_PATH;
	echo _OOS_INSTALL_NAME=$OOS_INSTALL_NAME >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_PARTITION_DISK_LABEL=$OOS_PARTITION_DISK_LABEL >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_PARTITIONS=$OOS_PARTITIONS >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_MOUNT_FOLDER=$OOS_MOUNT_FOLDER >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_ROOT_FOLDER=$OOS_ROOT_FOLDER >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_CLONE_FOLDER=$OOS_CLONE_FOLDER >> $OOS_INSTALL_CONF_PATH;

	echo _OOS_USE_PARTITIONING=$OOS_USE_PARTITIONING >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_MOUNTING=$OOS_USE_MOUNTING >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_REMOUNT=$OOS_USE_REMOUNT >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_STRAP=$OOS_USE_STRAP >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_PACSTRAP=$OOS_USE_PACSTRAP >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_SKELETON=$OOS_USE_SKELETON >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_BOOTLOADER=$OOS_USE_BOOTLOADER >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_USE_REBOOT=$OOS_USE_REBOOT >> $OOS_INSTALL_CONF_PATH;

	echo _OOS_DEFAULT_PACKAGES=$OOS_DEFAULT_PACKAGES >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_ADDITIONAL_PACKAGES=$OOS_ADDITIONAL_PACKAGES >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_INSTALL_PACKAGES=$OOS_INSTALL_PACKAGES >> $OOS_INSTALL_CONF_PATH;

	echo _OOS_LOCALE=$OOS_LOCALE >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_LANG=$OOS_LANG >> $OOS_INSTALL_CONF_PATH;

	echo _OOS_USE_GRUB=$OOS_USE_GRUB >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_BOOT_UEFI=$OOS_BOOT_UEFI >> $OOS_INSTALL_CONF_PATH;
	echo _OOS_BOOT_ID=$OOS_BOOT_ID >> $OOS_INSTALL_CONF_PATH;

	echo _OOS_ARCH=$OOS_ARCH >> $OOS_INSTALL_CONF_PATH;

	echo _OOS_UNMOUNT_AFTER_INSTALL=$OOS_UNMOUNT_AFTER_INSTALL >> $OOS_INSTALL_CONF_PATH;
	
	# Tell the script it's now stage 2
	touch stage2;
	exit;
else
	# TODO: Exit more gracefully, prompt again or alternatively save the config and fast track
	# here if the config is detected to be done already.
	log "Installation aborted.";
	exit 1;
fi
