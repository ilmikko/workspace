# 
# 0.8. Check
# Check that the script has all the variables it needs to perform a full installation.
# Convert everything vague to solid instructions now; we have all the information needed.
# This script also annotates if there are any potentially dangerous options.
# 

# requires: parted, awk, grep

log "Checking environment variables...";

# OOS_INSTALL_DEVICE
# Install device must be set
if [ "x$OOS_INSTALL_DEVICE" = "x" ]; then
	abort "OOS_INSTALL_DEVICE not set.";
fi
# Install device must exist
if ! [ -a "$OOS_INSTALL_DEVICE" ]; then
	abort "Device $OOS_INSTALL_DEVICE does not exist.";
fi

# PARTITIONING
# There must be enough space on the disk
bytes_available=$(parted "$OOS_INSTALL_DEVICE" unit B print 2>/dev/null | awk '/dev/ { gsub("B$","",$3); print $3}');
# parted /dev/sda unit B print | awk '/dev/ { gsub("B$","",$3); total = total + $3; } END { printf total }'

echo $bytes_available;

. $@;
