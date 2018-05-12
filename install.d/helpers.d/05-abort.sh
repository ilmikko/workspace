# Print a message and exit
abort(){
	error "$@";
	error "Aborting.";
	exit 1;
}

. $@;
