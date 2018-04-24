# Print a message and exit
function abort(){
	echo "[31m$1";
	echo "Aborting.[m";
	exit 1;
}

. $@;
