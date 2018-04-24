#
# 0.2. Probe
# Probes some system information that is useful during the installation process.
#

log "Getting system information...";

debug "OOS_SHELL=$OOS_SHELL";
debug "OOS_INSTALL_DEVICE=$OOS_INSTALL_DEVICE";

. $@;
