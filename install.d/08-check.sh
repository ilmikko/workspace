# 
# 0.8. Check
# Check that the script has all the variables it needs to perform a full installation.
# Convert everything vague to solid instructions now; we have all the information needed.
# This script also annotates if there are any potentially dangerous options.
# 

# requires: parted, awk, grep

log "Checking environment variables...";

# OOS_INSTALL_DEVICE
# Install device must be set
if [ "x$OOS_INSTALL_DEVICE" = "x" ]; then
	abort "OOS_INSTALL_DEVICE not set.";
fi
# Install device must exist
if ! [ -a "$OOS_INSTALL_DEVICE" ]; then
	abort "Device $OOS_INSTALL_DEVICE does not exist.";
fi

# PARTITIONING
# There must be enough space on the disk
available_space=$(parted "$OOS_INSTALL_DEVICE" unit B print 2>/dev/null | awk '/\/dev\/\w+:/ { gsub("B$","",$3); print $3}');
# parted /dev/sda unit B print | awk '/dev/ { gsub("B$","",$3); total = total + $3; } END { printf total }'

available_space_human=$(from_bytes $available_space);

echo There is $available_space_human available on $OOS_INSTALL_DEVICE;

# Take absolute sizes first, check that there is space available
partitions="ROOT $OOS_ROOT_SIZE SWAP $OOS_SWAP_SIZE BOOT $OOS_BOOT_SIZE VAR $OOS_VAR_SIZE HOME $OOS_HOME_SIZE";

# convert partitions to bytes, where available (ignore % for now)

for (( i=1 ; i<=10 ; i=i+2 )); do
	# get and convert the size
	part_byte_size=$(echo $partitions | awk '{ print $('$i'+1) }' | awk -f awk/to_bytes.awk);

	# replace the size
	partitions=$(echo $partitions | awk '{ sub($('$i'+1),"'$part_byte_size'",$0); print $0 }');
done

# TODO: awk list size
# TODO: awk regex test / indexof %
# TODO: how to convert the items before summing them together, we need a convert step
used_space=$(echo $partitions | awk '{ for (i=1;i<=10;i+=2) { if (sub("%$","",$(i+1))==0) { used_space += $(i+1) } } } END { print used_space }');
used_space_human="$(from_bytes $used_space)";

debug "Used space: $used_space";
debug "That is: $used_space_human";

remaining_space=$((available_space-used_space));
remaining_space_human="$(from_bytes $remaining_space)";
debug "This leaves $remaining_space for relative percentages.";
debug "That is: $remaining_space_human";

# If $remaining_space <= 0, (or ridiculously small), abort saying the disk needs more space for the partitions.
if [ "$remaining_space" -le "0" ]; then
	abort "The disk needs at least $used_space_human for the installation partitions.\nThere is only $available_space_human available on $OOS_INSTALL_DEVICE.\nPlease either resize your partition preferences or choose a different install device.";
fi

# Then, if $remaining_space > 0, convert the percentages to absolute values.


echo Partition table:;

. $@;
