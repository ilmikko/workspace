#
# 3. Strap
# Creates the necessary files for the chroot environment
#

oos_pacstrap() {
	# TODO: Can we do this without pacstrap, using pacman -r ?
	pacstrap $1 $OOS_DEFAULT_PACKAGES $OOS_INSTALL_PACKAGES;
}

oos_genfstab() {
	genfstab -U $1 >> $1/etc/fstab;
}

# Pacstrap the mount folder
oos_pacstrap $OOS_MOUNT_FOLDER;

# Generate the fstab file
oos_genfstab $OOS_MOUNT_FOLDER;

# Set the hostname and /etc/hosts
#oos_set_hosts;

# Set the time and locale settings
#oos_set_locale;

# next file
. $@;
