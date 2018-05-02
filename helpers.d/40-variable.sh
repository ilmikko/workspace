# Helpers for (environment) variables

variable_load_file() {
	cat $@;
}

variable_is_file() {
	# Variable is a callable file if it exists AND starts with ./
	[[ "$1" == "./"* ]] && [ -a "$1" ];
}

aggregate_variable() {
	varname_env=$(eval echo "\$$1");
	varname_conf=$(eval echo "\$_$1");
	varname_def=$(eval echo "\$$1_DEFAULT");

	if [ "x$varname_env" = "x" ]; then
		if [ "x$varname_conf" = "x" ]; then
			# Variable not set; use default
			# Even if default is none, that should be fine, the check will determine
			# whether it's a problem or not.
			env_var=$varname_def;
		else
			# Variable set in file / on runtime
			env_var=$varname_conf;
		fi
	else
		# Variable set in environment
		env_var=$varname_env;
	fi

	# If the variable name is a file, load it to env_var
	if variable_is_file $env_var; then
		env_var=$(variable_load_file $env_var);
	fi

	# Finally, update the original variable
	export $1="$env_var";
}

oos_set() {
	export $1=$2;
}

oos_get() {
	echo $(eval echo "\$$1");
}

. $@;
