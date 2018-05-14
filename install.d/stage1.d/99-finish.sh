	# Move to stage 2

	# Write the installation configuration file for the next stages, or to fast track if it fails
	export_config "OOS_INSTALL_DEVICE";
	export_config "OOS_INSTALL_NAME";

	export_config "OOS_PARTITION_DISK_LABEL";
	export_config "OOS_PARTITIONS";

	export_config "OOS_MOUNT_FOLDER";
	export_config "OOS_ROOT_FOLDER";
	export_config "OOS_CLONE_FOLDER";

	export_config "OOS_USE_PARTITIONING";
	export_config "OOS_USE_MOUNTING";
	export_config "OOS_USE_REMOUNT";
	export_config "OOS_USE_STRAP";
	export_config "OOS_USE_PACSTRAP";
	export_config "OOS_USE_SKELETON";
	export_config "OOS_USE_BOOTLOADER";
	export_config "OOS_USE_REBOOT";

	export_config "OOS_DEFAULT_PACKAGES";
	export_config "OOS_ADDITIONAL_PACKAGES";
	export_config "OOS_INSTALL_PACKAGES";

	export_config "OOS_LOCALE";
	export_config "OOS_LANG";

	export_config "OOS_USE_GRUB";
	export_config "OOS_BOOT_UEFI";
	export_config "OOS_BOOT_ID";

	export_config "OOS_UNMOUNT_AFTER_INSTALL";

	export_config "OOS_ARCH";

	echo export "\"OOS_INSTALL_DEVICE=$OOS_INSTALL_DEVICE\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_INSTALL_NAME=$OOS_INSTALL_NAME\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_PARTITION_DISK_LABEL=$OOS_PARTITION_DISK_LABEL\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_PARTITIONS=${OOS_PARTITIONS[@]}\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_MOUNT_FOLDER=$OOS_MOUNT_FOLDER\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_ROOT_FOLDER=$OOS_ROOT_FOLDER\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_CLONE_FOLDER=$OOS_CLONE_FOLDER\"" >> $OOS_INSTALL_CONF_PATH;

	echo export "\"OOS_USE_PARTITIONING=$OOS_USE_PARTITIONING\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_MOUNTING=$OOS_USE_MOUNTING\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_REMOUNT=$OOS_USE_REMOUNT\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_STRAP=$OOS_USE_STRAP\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_PACSTRAP=$OOS_USE_PACSTRAP\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_SKELETON=$OOS_USE_SKELETON\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_BOOTLOADER=$OOS_USE_BOOTLOADER\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_USE_REBOOT=$OOS_USE_REBOOT\"" >> $OOS_INSTALL_CONF_PATH;

	echo export "\"OOS_DEFAULT_PACKAGES=$OOS_DEFAULT_PACKAGES\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_ADDITIONAL_PACKAGES=$OOS_ADDITIONAL_PACKAGES\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_INSTALL_PACKAGES=$OOS_INSTALL_PACKAGES\"" >> $OOS_INSTALL_CONF_PATH;

	echo export "\"OOS_LOCALE=$OOS_LOCALE\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_LANG=$OOS_LANG\"" >> $OOS_INSTALL_CONF_PATH;

	echo export "\"OOS_USE_GRUB=$OOS_USE_GRUB\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_BOOT_UEFI=$OOS_BOOT_UEFI\"" >> $OOS_INSTALL_CONF_PATH;
	echo export "\"OOS_BOOT_ID=$OOS_BOOT_ID\"" >> $OOS_INSTALL_CONF_PATH;

	echo export "\"OOS_ARCH=$OOS_ARCH\"" >> $OOS_INSTALL_CONF_PATH;

	echo export "\"OOS_UNMOUNT_AFTER_INSTALL=$OOS_UNMOUNT_AFTER_INSTALL\"" >> $OOS_INSTALL_CONF_PATH;

	# Copy this as a previous installation so we can skip straight to this install if we want to
	cp -rv "$OOS_INSTALL_CONF_PATH" "$OOS_INSTALL_CONF_PATH.prev";
	
	# Tell the script it's now stage 2
	touch stage2;
	exit;
