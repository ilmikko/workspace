#
# 0.8.1. Partition check
# Check that the disk has enough space for the partitions, and the
# partitions make sense (e.g. percentages sum up to 100%)
#

# TODO: This partitioning section needs some heavy cleaning up.
# TODO: I need to figure out lists in bash properly

# Input: a device /dev/* of which space to check.
get_available_space() {
	parted "$1" unit B print 2>/dev/null | awk '/\/dev\/\w+:/ { gsub("B$","",$3); print $3; }';
}

# There must be enough space on the disk
available_space=$(get_available_space "$OOS_INSTALL_DEVICE");
available_space_human=$(from_bytes $available_space);

log "There is $available_space_human available on $OOS_INSTALL_DEVICE";

# Take absolute sizes first, check that there is space available
partitions="ROOT $OOS_ROOT_SIZE SWAP $OOS_SWAP_SIZE BOOT $OOS_BOOT_SIZE VAR $OOS_VAR_SIZE HOME $OOS_HOME_SIZE";
partitions_new=(ROOT $OOS_ROOT_SIZE);

exit 255;

# convert partitions to bytes, where available (ignore % for now)
partition_count=5;

for (( i=1; i<=partition_count*2; i=i+2 )); do
	# get the size and check if it's absolute (not a percentage)
	part_byte_size=$(echo $partitions | awk '{ print $('$i'+1) }');

	if [[ "$part_byte_size" == *\% ]]; then
		# percentage; skip this loop
		continue;
	else
		part_byte_size=$(echo $part_byte_size | awk -f awk/to_bytes.awk);
		# replace the size
		partitions=$(echo $partitions | awk '{ sub($('$i'+1),"'$part_byte_size'",$0); print $0 }');
	fi
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

# TODO: Convert the percentages to percentages between 0%..100%?

# Check that the percentages add up to 100%
percentage_sum=$(echo $partitions | awk '{ for (i=1; i<=NF; i+=2) { perc=$(i+1); if (perc ~ /%$/){ total+=perc; } } } END { print total; }');
if [ ! -z "$percentage_sum" ] && [ "$percentage_sum" != 100 ]; then
	abort "The partition percentages do not sum up to 100%%.\nThey sum up to $percentage_sum%%.\nPlease check your configuration.";
fi

# Then, if $remaining_space > 0, convert the percentages to absolute values.
for (( i=1; i<=partition_count*2; i=i+2 )); do
	# get the value and check if it is a percentage
	part_percentage=$(echo $partitions | awk '{ print $('$i'+1) }');

	if [[ "$part_percentage" != *\% ]]; then
		# skip this loop
		continue;
	else
		# convert the percentage to an actual size
		part_byte_size=$(echo $part_percentage $remaining_space | awk -f awk/percentage.awk);
		# replace the percentage
		partitions=$(echo $partitions | awk '{ sub($('$i'+1),"'$part_byte_size'",$0); print $0 }');
	fi
done

echo Partition table:;
for (( i=1; i<=partition_count*2; i=i+2 )); do
	# Partition names
	echo $partitions | awk '{ printf("Part "$('$i')": "); }';
	# Partition sizes
	echo $partitions | awk '{ print($('$i'+1)); }' | awk -f awk/from_bytes.awk;
done

. $@;
