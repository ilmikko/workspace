#
# 1.2. Check strap
# Check all the miscellaneous items needed in 30-strap
# For example, locales, timezones...
#

# Check that timezone is correct (not a fatal error)
[ -a "/usr/share/zoneinfo/$OOS_TIMEZONE" ] || confirm "Time zone $OOS_TIMEZONE not found in zoneinfo. Are you sure it is correct";

. $@;
