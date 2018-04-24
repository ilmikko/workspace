#!/bin/sh
# General roadmap for a workspace installation:

# 1. Barebone linux installation
# 1.1. Linux config
# 2. Shell
# 2.1. Shell config
# 3. Graphical interface
# 3.1. Themes
# 4. Graphical toolsets / applications
# 5. Finalization

# Change working directory to the directory of the install script
cd $(dirname $0);

echo "Preparing...";

# Get the helpers
. ./helpers.d/*;

echo "Initializing...";

# Call the rest of our scripts in order.
. ./install.d/*;
