# Units, a helper to convert different units to others

# Convert a byte declaration to bytes
# For example, 1MB -> 1000000 bytes
to_bytes() {
	echo $1 | awk -f awk/to_bytes.awk;
}

# Get percentage of a value
percentage() {
	echo $1 $2 | awk -f awk/percentage.awk;
}

. $@;
