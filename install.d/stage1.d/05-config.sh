# Load the config file if it exists

# If we have loaded the config already and can skip this step
if [ "$OOS_CONFIG_LOADED" != 1 ]; then
	if [ -f "./config.conf" ]; then
		log "A configuration file was found in $(realpath "./config.conf").";
		if assume "Do you want to use this file"; then
			# Load the config file
			. "./config.conf";
			OOS_CONFIG_LOADED=1;
			
			# Go to next file
			. $@;
			exit;
		fi
	fi

	# Manual config
	log "Manual configuration:";
	log "UNSUPPORTED AS OF NOW";
	read;
fi

# Next file
. $@;
