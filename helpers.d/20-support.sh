# Determines which shells are supported, for now.

get_shell() {
	echo $(basename $(readlink /proc/$$/exe));
}

shell_supported() {
	case "$@" in
		"zsh")
			true && return;
			;;
		*)
			false && return;
			;;
	esac
}

check_support() {
	assert_command basename;
}

assert_command() {
	if ! command -v $@ >/dev/null 2>&1; then
		abort "Command $@ not supported.\nPlease check your \$PATH";
	fi
}

. $@;
