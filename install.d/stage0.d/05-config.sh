# 0.1. Config
# Gathers all the information that we need to fully automate the rest of the installation process.
# The config will be saved into a file and dragged across as needed.
# The idea is to only ask the user once so that no one has to babysit the installation process.

# TODO: On stage 2..3, we only need to source $OOS_INSTALL_CONF_LOCATION and we're good to go

# An option to fast track if the config file is found already
if [ -f "$OOS_INSTALL_CONF_PATH.prev" ]; then
	log "A previous install file was found in $(realpath "$OOS_INSTALL_CONF_PATH.prev").";
	if [ -a "stage2" ] || assume "Do you want to use this file"; then
		# Load the config file
		. "$OOS_INSTALL_CONF_PATH.prev";
		OOS_CONFIG_LOADED=1;
		
		# Go to next file
		. $@;
		exit;
	fi
fi

# Next file
. $@;
