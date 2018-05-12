oos_filesystem_supported() {
	case $1 in
		[Ee][Xx][Tt][234] | [Ff][Aa][Tt]32 | [Ss][Ww][Aa][Pp])
			true && return;
			;;
		*)
			false || return;
			;;
	esac
}

oos_partlabel_supported() {
	case $1 in
		[Gg][Pp][Tt] | [Dd][Oo][Ss] | [Mm][Bb][Rr] | [Ss][Uu][Nn] | [Ss][Gg][Ii] | [Ii][Rr][Ii][Xx])
			true && return;
			;;
		*)
			false || return;
			;;
	esac
}

. $@;
