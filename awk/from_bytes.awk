#!/usr/bin/env awk
function abs(v) { return v < 0 ? -v : v }
{
	bytes=$1;

	order=log(abs(bytes))/log(2);

	# Remove decimal part
	sub("\\..*$","",order);

	str = bytes;

	if (order<10) {
		unit = "B";
	} else if (order<20) {
		str /= 1024;
		unit = "KiB";
	} else if (order<30) {
		str /= 1048576;
		unit = "MiB";
	} else if (order<40) {
		str /= 1073741824;
		unit = "GiB";
	} else if (order<50) {
		str /= 1099511627776;
		unit = "TiB";
	} else {
		str = str"B";
	}

	printf("%.1f"unit"\n",str);
}
