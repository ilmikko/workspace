#
# 1.2. Check strap
# Check all the miscellaneous items needed in 30-strap
# For example, locales, timezones...
#

# Check that timezone is correct (not a fatal error)
[ -a "/usr/share/zoneinfo/$OOS_TIMEZONE" ] || confirm "Time zone $OOS_TIMEZONE not found in zoneinfo. Are you sure it is correct";

if [ ! -z "$OOS_MOUNT_FOLDER" ]; then
	# Mount folder should exist if it is defined (otherwise we'll use temp)
	[ ! -d "$OOS_MOUNT_FOLDER" ] && abort "Mount folder does not exist, or is not a folder." "Please ensure $OOS_MOUNT_FOLDER exists and is a writeable directory.";

	# Mount folder should not be root
	[ "$OOS_MOUNT_FOLDER" = / ] && abort "Mount folder should not be the root folder!";
fi

. $@;
