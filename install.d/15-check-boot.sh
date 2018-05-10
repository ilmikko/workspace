#
# 1.5. Check boot instructions
#

if [ "$OOS_BOOT_UEFI" = 1 ]; then
	# If using UEFI, need efibootmgr and efivars
	[ -a /sys/firmware/efi/efivars ] || abort "Cannot probe efivars; are you sure you are booted inside EFI mode?";
	assert_command efibootmgr;
fi

. $@;
