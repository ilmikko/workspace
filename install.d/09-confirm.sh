# 0.9. Confirm
# Final confirmation of the installation, after this the install script will take over.
# This should be verbose enough to show everything that was configured, and this script is also
# responsible for storing the config file for the later installation stages.

echo;
echo "================================================================================";
echo "             Please make sure the following information is correct.";
echo "================================================================================";
echo;
echo "Installation device: $OOS_INSTALL_DEVICE";
echo;
echo "Please type in uppercase YES to begin the installation process.";
read -p '> ' confirmation;

if [ $confirmation == "YES" ]; then
	echo "Starting installation... you might want to grab a cup of tea now.";
	# Next file, after confirmation
	. $@;
else
	# TODO: Exit more gracefully, prompt again or alternatively save the config and fast track
	# here if the config is detected to be done already.
	echo "Installation aborted.";
	exit 1;
fi

