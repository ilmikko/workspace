# 0. Config
# Calls all necessary installation files, and guides through the installation process.

log "Stage 2...";
log "Command check...";

# These commands are needed for stage 2
assert_commands awk sudo parted mount fdisk printf cat rm cp mktemp dirname basename sync uname sed;

# These should be able to be installed just for the installation's sake
# they don't exist on regular machines usually
assert_commands pacstrap genfstab;

# Next file
. $@;
