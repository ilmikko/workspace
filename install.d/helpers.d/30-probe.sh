# Probing helpers

# Current running distribution
distribution() {
	if command_available lsb_release; then
		# Get the ID from lsb_release
		release=$(lsb_release -a | grep -m 1 -i ID | grep -o '\w*$');
		if ! [ "x$release" = "x" ]; then
			echo $release;
			return;
		fi
	fi

	# Try to get the ID from etc file release
	release=$(cat /etc/*release* | grep -m 1 -i ID | grep -o '\w*$');
	if ! [ "x$release" = "x" ]; then
		echo $release;
		return;
	fi

	echo "unknown";
}

# Architecture
arch() {
	uname -m;
}

. $@;
