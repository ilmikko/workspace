#
# 1.5. Check boot instructions
#

if [ "$OOS_BOOT_UEFI" = 1 ]; then
	# If using UEFI, need efibootmgr and efivars
	[ -a /sys/firmware/efi/efivars ] || abort "Cannot probe efivars; are you sure you are booted inside EFI mode?";

	# efibootmgr needs to be installed (not really, because we can install those with pacstrap)
	assert_command efibootmgr;
fi

# install grub if using grub
[ "$OOS_USE_GRUB" = 1 ] && OOS_ADDITIONAL_PACKAGES="grub $OOS_ADDITIONAL_PACKAGES";
# install efibootmgr if using UEFI
[ "$OOS_BOOT_UEFI" = 1 ] && OOS_ADDITIONAL_PACKAGES="efibootmgr $OOS_ADDITIONAL_PACKAGES";

. $@;
