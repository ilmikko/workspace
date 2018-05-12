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
[ -z "$OOS_INSTALL_DEVICE" ] && abort "OOS_INSTALL_DEVICE not set.";

# Install device must exist
[ -a "$OOS_INSTALL_DEVICE" ] || abort "Device $OOS_INSTALL_DEVICE does not exist.";

# Install device must make sense (TODO: Make this overrideable)
[[ "$OOS_INSTALL_DEVICE" != /dev/* ]] && abort "Cannot install on unknown device type: $OOS_INSTALL_DEVICE";

. $@;
