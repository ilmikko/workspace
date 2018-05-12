confirm(){
	read -r -p "$1 [y/N]? " confirmation;
	case "$confirmation" in
		[Yy][Ee][Ss]|[Yy])
			true && return;
			;;
		*)
			false && return;
			;;
	esac
}

assume(){
	read -r -p "$1 [Y/n]? " confirmation;
	case "$confirmation" in
		[Nn][Oo]|[Nn])
			false && return;
			;;
		*)
			true && return;
			;;
	esac
}

. $@;
