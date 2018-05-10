#
# 3. Strap
# Creates the necessary files for the chroot environment
#

oos_pacstrap() {
	# TODO: Can we do this without pacstrap, using pacman -r ?
	until pacstrap $1 $OOS_DEFAULT_PACKAGES; do
		warning "Pacstrap failed to install some packages; trying again...";
		sleep 1;
	done
}

oos_genfstab() {
	# Disable all swap that is not on this device, because we don't want that in the fstab
	swap_in_use=$(swapon -s | awk '/^\/dev/ { print $1 }' | grep -v $OOS_INSTALL_DEVICE);
	if ! [ -z "$swap_in_use" ]; then
		log "Devices $swap_in_use are used for swap, but not for the install." "Disabling temporarily to generate the fstab file...";
		swapoff $swap_in_use;
	fi

	debug "Genfstab -U $1";
	genfstab -U $1 > $1/etc/fstab;

	# Enable the swap that we disabled
	log "Enabling $swap_in_use after fstab generation...";
	swapon $swap_in_use;
}

oos_set_hosts() {
	log "Setting up hosts...";
	echo $OOS_HOSTNAME > $1/etc/hostname;

	# TODO: Set hosts file (should it be a skel?)
	# ! [ -z "$OOS_HOSTS" ] && echo $OOS_HOSTS >> $1/etc/hosts;
}

oos_set_locale() {
	log "Setting locale...";

	# locale.gen
	debug "locale.gen...";
	# comment out every uncommented line in the locale.gen file
	locales=$(cat $1/etc/locale.gen | awk '{ sub("^#","",$0); print "#"$0 }');

	OOS_LOCALE=(${OOS_LOCALE[@]});
	for (( i=0; i<${#OOS_LOCALE[@]}; i++ )) do
		loc=${OOS_LOCALE[$i]};
		debug "Enable locale $loc";
		locales=$(echo "$locales" | awk '{ sub("#'$loc'","'$loc'",$0); print $0 }');
	done
	echo "$locales" > $1/etc/locale.gen;

	# TODO: Insert more locale options
	debug "locale.conf...";
	echo LOCALE=${OOS_LOCALE[0]} > $1/etc/locale.conf;
	echo LANG=$OOS_LANG >> $1/etc/locale.conf;

	# Timezone
	# (might have to do this on the other side, phase 3, as hard links should not be done at this time)
	# ln -sf $1/usr/share/zoneinfo/$OOS_TIMEZONE $1/etc/localtime;
	# hwclock --systohc
}

# Pacstrap the mount folder
if [ "$OOS_USE_PACSTRAP" = 1 ]; then
	oos_pacstrap $OOS_ROOT_FOLDER;
else
	warning "Skipping pacstrap step...";
fi

# Generate the fstab file
oos_genfstab $OOS_ROOT_FOLDER;

# Set the hostname and /etc/hosts
oos_set_hosts $OOS_ROOT_FOLDER;

# Set the time and locale settings
oos_set_locale $OOS_ROOT_FOLDER;

# next file
. $@;
