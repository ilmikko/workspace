# 0.1. Config
# Gathers all the information that we need to fully automate the rest of the installation process.
# The config will be saved into a file and dragged across as needed.
# The idea is to only ask the user once so that no one has to babysit the installation process.

# An option to fast track if the config file is found already
echo;
if [ -f "./install.conf" ]; then
	echo "The configuration file was found in $(realpath ./install.conf).";
	echo "Do you want to use this file?";
	if [ $(confirm) ]; then
		# Next file
		echo "USING FILE";
		. $@;
		exit 0;
	fi
fi

echo "Please configure the installation below.";
# TODO: More configuration options
read;

# Next file
. $@;
