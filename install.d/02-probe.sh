#
# 0.2. Probe
# Probes some system information that is useful during the installation process.
#

log "Getting system information...";
OOS_DISTRIBUTION=$(distribution);

debug "OOS_SHELL=$OOS_SHELL";
debug "OOS_INSTALL_DEVICE=$OOS_INSTALL_DEVICE";
debug "OOS_DISTRIBUTION=$OOS_DISTRIBUTION";

log "Checking runtime environment...";

# Check if we are already running Arch Linux. If we are, our life becomes so much simpler.
case "$OOS_DISTRIBUTION" in
	[Aa][Rr][Cc][Hh]|[Aa][Rr][Cc][Hh]\ [Ll][Ii][Nn][Uu][Xx])
		debug "Distribution ok";
		;;
	*)
		error "Non-arch installation is currently unsupported. Sorry!\nIf you choose to continue, there is a very high chance things will break.";
		confirm "Are you sure you want to continue" || exit 0;
		;;
esac

# TODO: I'm not sure where these should go as of now
log "Command check...";

assert_command awk;
assert_command sudo;
assert_command parted;
assert_command mount;
assert_command fdisk;
assert_command printf;

. $@;
