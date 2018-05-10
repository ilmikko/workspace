#
# 5. Boot settings
# Install either UEFI/BIOS bootloader (grub) and prepare the system for reboot
#

if [ "$OOS_USE_GRUB" = 1 ]; then
	oos_install_bootloader() {
		log "Installing bootloader...";
		
		if [ "$OOS_BOOT_UEFI" = 1 ]; then
			# UEFI path
			log "Installing grub on $OOS_INSTALL_DEVICE... (UEFI)";
			arch-chroot $1 grub-install --target=$OOS_ARCH-efi --efi-directory=/boot --bootloader-id=OrciOS $OOS_INSTALL_DEVICE;
		else
			# BIOS path
			log "Installing grub on $OOS_INSTALL_DEVICE... (BIOS)";
			arch-chroot $1 grub-install --target=$OOS_ARCH $OOS_INSTALL_DEVICE;
		fi

		# Grub config
		log "Configuring grub...";
		arch-chroot $1 grub-mkconfig -o $1/boot/grub/grub.cfg;
	}
else
	warning "Not using grub as a bootloader, not using a bootloader at all!";
	oos_install_bootloader() {
		warning "oos_install_bootloader unimplemented";
	}
fi

oos_mkinitcpio() {
	# Run the command in the chroot
	log "Making the initcpio image...";
	# TODO: Try to do this without (arch-)chroot
	arch-chroot $1 mkinitcpio -p linux;
}

oos_install_bootloader $OOS_ROOT_FOLDER;

oos_mkinitcpio $OOS_ROOT_FOLDER;

. $@;
