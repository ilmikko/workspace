	# Move to stage 2

	# Write the installation configuration file for the next stages, or to fast track if it fails
	export_config "OOS_INSTALL_DEVICE";
	export_config "OOS_INSTALL_NAME";

	export_config "OOS_PARTITION_DISK_LABEL";

	OOS_PARTITIONS="${OOS_PARTITIONS[@]}";

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

	# Copy this as a previous installation so we can skip straight to this install if we want to
	cp -rv "$OOS_INSTALL_CONF_PATH" "$OOS_INSTALL_CONF_PATH.prev";
	
	# Tell the script it's now stage 2
	touch stage2;
	exit;
