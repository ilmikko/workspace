# 0.9. Confirm
# Final confirmation of the installation, after this the install script will take over.
# This should be verbose enough to show everything that was configured, and this script is also
# responsible for storing the config file for the later installation stages.

log;
log "================================================================================";
log "             Please make sure the following information is correct.";
log "================================================================================";
log;
log "Installation device: $OOS_INSTALL_DEVICE";
log "Installation packages: $OOS_INSTALL_PACKAGES $OOS_DEFAULT_PACKAGES $OOS_ADDITIONAL_PACKAGES";
log "Installation name: $OOS_INSTALL_NAME";
log;
log "Partitions:";
pretty_print_partitions ${OOS_PARTITIONS[@]};
log;
log "You are about to install a new linux workspace on $OOS_INSTALL_DEVICE.";
log "Please type in uppercase YES to begin the installation process.";

if [ "$OOS_FASTTRACK" != "1" ]; then
	read -p '> ' confirmation;
else
	confirmation="YES";
fi

if [ "$confirmation" = "YES" ]; then
	log "Starting installation... you might want to grab a cup of tea now.";
	. $@;
else
	# TODO: Exit more gracefully, prompt again or alternatively save the config and fast track
	# here if the config is detected to be done already.
	log "Installation aborted.";
	exit 1;
fi
