# 0.1. Config
# Gathers all the information that we need to fully automate the rest of the installation process.
# The config will be saved into a file and dragged across as needed.
# The idea is to only ask the user once so that no one has to babysit the installation process.

# An option to fast track if the config file is found already
log;
if [ -f "./install.conf" ]; then
	log "The configuration file was found in $(realpath ./install.conf).";
	if assume "Do you want to use this file"; then
		# Load the config file
		. ./install.conf;
		
		# Go to next file
		. $@;
		exit;
	fi
fi

log "Please configure the installation below.";
# TODO: More configuration options
read;

# Next file
. $@;
