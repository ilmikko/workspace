# Install any additional packages now that we have booted and connected to the internet

oos_install_strap() {
	pacman --noconfirm -S $OOS_INSTALL_PACKAGES;
}

oos_install_strap;

. $@;
