#!/usr/bin/env awk
{
	type=$1;
	bytes=$1;

	sub("^[0-9.]*","",type);
	sub("[^0-9.]*$","",bytes);

	type=toupper(type);

	switch(type){
		case "TIB":case "T":
		bytes*=1099511627776;
		break;
		case "GIB":case "G":
		bytes*=1073741824;
		break;
		case "MIB":case "M":
		bytes*=1048576;
		break;
		case "KIB":case "K":
		bytes*=1024;
		break;
		case "TB":
		bytes*=1e12;
		break;
		case "GB":
		bytes*=1e9;
		break;
		case "MB":
		bytes*=1e6;
		break;
		case "KB":
		bytes*=1e3;
		break;
		case "B":break;
	}
	printf("%i\n", bytes);
}
