#!/usr/bin/env awk
{
	printf("%i%\n", ($1/$2)*100);
}
