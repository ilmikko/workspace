log "Stage 1...";

# Determine if we are in a correct shell; the installer will run nevertheless, but
# it will warn that there might be consequences as I haven't tested all shells yet.
OOS_SHELL=$(get_shell);
debug "Running in shell: $OOS_SHELL";

if ! shell_supported $OOS_SHELL; then
	confirm "Shell $OOS_SHELL is not supported, the installation may misbehave. Do you want to continue" || abort "Installation cancelled.";
fi

# Next file
. $@;
