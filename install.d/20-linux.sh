# 1. Linux
# This installs a barebone linux distribution. As we have a working internet connection, we can get the most of it done here.

log "Installing linux on $OOS_INSTALL_DEVICE...";

# FAILSAFE: Do NOT use /dev/sda or the current root device.
# This is only to save my butt when debugging the program.

if [ $OOS_INSTALL_DEVICE = '/dev/sda' ]; then
	abort "You were just about to wipe your main drive.";
	exit 5;
fi

. $@;
