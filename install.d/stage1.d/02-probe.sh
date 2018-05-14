#
# 0.2. Probe
# Probes some system information that is useful during the installation process.
#

# TODO: Maybe not needed in 2..3, stage 1?

log "Getting system information...";
OOS_DISTRIBUTION=$(distribution);
OOS_ARCH=$(arch);

export_config "OOS_SHELL";
export_config "OOS_ARCH";
export_config "OOS_DISTRIBUTION";

log "Checking runtime environment...";

# Check if we are already running Arch Linux. If we are, our life becomes so much simpler.
case "$OOS_DISTRIBUTION" in
	[Aa][Rr][Cc][Hh]|[Aa][Rr][Cc][Hh]\ [Ll][Ii][Nn][Uu][Xx])
		debug "Distribution ok";
		;;
	*)
		error "Non-arch installation is currently unsupported. Sorry!" "If you choose to continue, there is a very high chance things will break.";
		confirm "Are you sure you want to continue" || exit 0;
		;;
esac

case "$OOS_ARCH" in
	[Xx]86_64)
		debug "Architecture ok";
		;;
	*)
		error "Your architecture ($OOS_ARCH) is unsupported. Sorry!" "You can still choose to continue, but the script might break.";
		confirm "Are you sure you want to continue" || exit 0;
esac

. $@;
