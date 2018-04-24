# 
# 0.8. Check
# Check that the script has all the variables it needs to perform a full installation.
# This script also annotates if there are any potentially dangerous options.
# 

echo "Checking environment variables...";

# Install device is set
if [ "x$OOS_INSTALL_DEVICE"=="x" ]; then
	abort "OOS_INSTALL_DEVICE not set.";
	echo "OOS_INSTALL_DEVICE not set.";
	echo "Aborting.";
	exit 1;
fi

. $@;
