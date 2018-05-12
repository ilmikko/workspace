# 0. Config
# Calls all necessary installation files, and guides through the installation process.

log "Stage 2...";

# Determine if we are in a correct shell; the installer will run nevertheless, but
# it will warn that there might be consequences as I haven't tested all shells yet.
OOS_SHELL=$(get_shell);
debug "Running in shell: $OOS_SHELL";

if ! shell_supported $OOS_SHELL; then
	warning "Shell $OOS_SHELL is not supported.\nThe installation may misbehave.";
fi

log "Command check...";

# These commands are needed for stage 2
assert_commands awk sudo parted mount fdisk printf cat rm cp mktemp dirname basename sync uname sed;

# These should be able to be installed just for the installation's sake
# they don't exist on regular machines usually
assert_commands pacstrap genfstab;

# Next file
. $@;
