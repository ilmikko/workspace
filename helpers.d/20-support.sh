# Determines which shells are supported, for now.

get_shell() {
	echo $(basename $(readlink /proc/$$/exe));
}

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

check_support() {
	assert_command readlink;
	assert_command dirname;
	assert_command basename;
}

assert_command() {
	if ! command_available "$@"; then
		abort "Command $@ not supported.\nPlease check your \$PATH";
	fi
}

. $@;
