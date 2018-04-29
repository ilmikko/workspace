#!/usr/bin/env bash
# General roadmap for a workspace installation:

# 1. Barebone linux installation
# 1.1. Linux config
# 2. Shell
# 2.1. Shell config
# 3. Graphical interface
# 3.1. Themes
# 4. Graphical toolsets / applications
# 5. Finalization

echo "Preparing...";

LANG=C

fatal_error(){
	echo "Fatal error: The installation cannot continue.";
	echo "$@";
	echo "Please check your shell version, as this should not happen on modern shells.";
	exit 3;
}

command_available(){
	command -v "$@" >/dev/null 2>&1;
}

# Sanity checks

if ! command_available command; then
	fatal_error "Cannot determine which commands are available.";
fi

# If not running as root, try again as root.
if [ "$EUID" != 0 ]; then
	if command_available sudo; then
		echo "Not running as root, retrying as root...";
		sudo $0 $@;
		exit;
	else
		fatal_error "Not running as root and sudo not found. Please run the script as root manually.";
	fi
fi


# Sourcing files

if ! command_available .; then
	# Try using 'source' to source files
	if ! command_available source; then
		# Sourcing isn't available for some reason, the system is not sane for installation
		fatal_error "Cannot source files, because neither . or source is available.";
	else
		# Source exists but . doesn't
		echo "Warning: Using alternative method for sourcing. The program may misbehave.";
		.() {
			source "$@";
		}
	fi
fi

# Dirname

if ! command_available dirname; then
	fatal_error "Cannot determine directory names without dirname.";
fi

# Change working directory to the directory of the install script
cd $(dirname $0);

# Get the helpers
. ./helpers.d/*;

# Test that the helpers are loaded and sane
if ! sane; then
	echo "Error: The installation cannot continue; helpers are insane.";
	exit 2;
fi

# Check that we have all the prerequisite binaries
check_support;

# Check if arguments were provided.
if [ -z "$1" ]; then
	debug "Initializing...";

	# Call the rest of our scripts in order.
	. ./install.d/*;
else
	# Fast track to arguments
	. $@;
fi
