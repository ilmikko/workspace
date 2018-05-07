# Determines which shells are supported, for now.

# Get the current shell that is running.
get_shell() {
	echo $(basename $(readlink /proc/$$/exe));
}

# Returns true if shell is supported.
shell_supported() {
	case "$@" in
		"bash")
			true && return;
			;;
		*)
			false && return;
			;;
	esac
}

# Check that every command we use is supported.
check_support() {
	assert_command readlink;
	assert_command dirname;
	assert_command basename;
	assert_command grep;
}

# Abort if a given command is not supported.
assert_command() {
	if ! command_available "$@"; then
		abort "Command $@ not supported.\nPlease check your \$PATH, or install the required binaries.";
	fi
}

. $@;
