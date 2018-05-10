#
# 5. Boot settings
# Install either UEFI/BIOS bootloader (grub) and prepare the system for reboot
#

oos_mkinitcpio() {
	# Run the command in the chroot
	log "Making the initcpio image...";
	# TODO: Try to do this without (arch-)chroot
	arch-chroot $1 mkinitcpio -p linux;
}

oos_mkinitcpio $OOS_ROOT_FOLDER;

. $@;
