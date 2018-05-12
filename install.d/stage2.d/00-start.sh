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

assert_command awk;
assert_command sudo;
assert_command parted;
assert_command mount;
assert_command fdisk;
assert_command printf;
assert_command cat;
assert_command rm;
assert_command cp;
assert_command mktemp;
assert_command dirname;
assert_command basename;
assert_command sync;
assert_command uname;
assert_command sed;

# These should be able to be installed just for the installation's sake
# they don't exist on regular machines usually
assert_command pacstrap;
assert_command genfstab;

# Next file
. $@;
