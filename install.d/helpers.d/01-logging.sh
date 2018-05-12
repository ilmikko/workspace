# Various logging utilities

# Consistent echo across devices, if possible
if command -v printf >/dev/null 2>&1; then
	log(){
		printf "%s\n" "$@";
	}
else
	log(){
		echo -e "$@";
	}
fi

error(){
	log "[31mError: $@[m";
}
warning(){
	log "[33mWarning: $@[m";
}
debug(){
	log "[34mDebug: $@[m";
}

. $@;
