#!/usr/bin/env awk
{
	sub("%$","",$1);
	printf("%i\n", $2*($1/100));
}
