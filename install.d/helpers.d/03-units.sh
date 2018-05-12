# Units, a helper to convert different units to others

# Convert a byte declaration to bytes
# For example, 1MB -> 1000000 bytes
to_bytes() {
	echo $1 | awk -f $OOS_AWK_PATH/to_bytes.awk;
}

# Convert bytes to a byte declaration
# For example, 1000000 bytes -> 976.6KiB
# (do note that this is a destructive operation, only for the sake of human readability)
from_bytes() {
	echo $1 | awk -f $OOS_AWK_PATH/from_bytes.awk;
}

# Get percentage of a value
from_percentage() {
	echo $1 $2 | awk -f $OOS_AWK_PATH/from_percentage.awk;
}

to_percentage() {
	echo $1 $2 | awk -f $OOS_AWK_PATH/to_percentage.awk;
}

. $@;
