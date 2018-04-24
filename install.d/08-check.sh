# 
# 0.8. Check
# Check that the script has all the variables it needs to perform a full installation.
# This script also annotates if there are any potentially dangerous options.
# 

log "Checking environment variables...";

# Install device is set
if [ "x$OOS_INSTALL_DEVICE" = "x" ]; then
	abort "OOS_INSTALL_DEVICE not set.";
fi

. $@;
