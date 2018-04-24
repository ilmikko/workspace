# 0. Config
# Calls all necessary installation files, and guides through the installation process.

# Determine if we are in a correct shell; the installer will run nevertheless, but
# it will warn that there might be consequences as I haven't tested all shells yet.
OOS_SHELL=$(get_shell);

debug "Running in shell: $OOS_SHELL";

if ! shell_supported $OOS_SHELL; then
	warning "Shell $OOS_SHELL is not supported.\nThe installation may misbehave.";
fi

# Next file
. $@;
