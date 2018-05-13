# Load the config file if it exists

if [ -f "./config.conf" ]; then
	log "A configuration file was found in $(realpath "./config.conf").";
	if assume "Do you want to use this file"; then
		# Load the config file
		. "./config.conf";
		
		# Go to next file
		. $@;
		exit;
	fi
else
	# Manual config
	log "Manual configuration:";
	log "UNSUPPORTED AS OF NOW";
	read;
fi

# Next file
. $@;
