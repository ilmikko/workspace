# Units, a helper to convert different units to others

# Convert a byte declaration to bytes
# For example, 1MB -> 1000000 bytes
to_bytes() {
	bytes=$(echo $1 | awk '{ type=$1; bytes=$1;\
		sub("^[0-9.]*","",type);\
		sub("[^0-9.]*$","",bytes);\
		type=toupper(type);\
		switch(type){\
		case "TIB":case "T":bytes*=1099511627776;break;\
		case "TB":bytes*=1e12;break;\
		case "GIB":case "G":bytes*=1073741824;break;\
		case "GB":bytes*=1e9;break;\
		case "MIB":case "M":bytes*=1048576;break;\
		case "MB":bytes*=1e6;break;\
		case "KIB":case "K":bytes*=1024;break;\
		case "KB":bytes*=1e3;break;\
		case "B":break;\
	 	}\
		printf("%i\n", bytes);
 	}');
	echo $bytes;
}

# Get percentage of a value
percentage() {
	echo $(echo $1 $2 | awk '{ sub("%$","",$1); printf("%i\n", $2*($1/100));}');
}

. $@;
