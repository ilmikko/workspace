# 0. Config
# Calls all necessary installation files, and guides through the installation process.

echo "Please choose the device you would like to install the workspace to.";
# TODO: Get the device
OOS_INSTALL_DEVICE=/dev/sda

echo "You are about to install a new linux workspace on $OOS_INSTALL_DEVICE.";

# Next file
. $@;
