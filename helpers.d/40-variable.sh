# Helpers for (environment) variables

aggregate_variable() {
	varname_env=$(eval echo "\$$1");
	varname_conf=$(eval echo "\$_$1");
	varname_def=$(eval echo "\$$1_DEFAULT");

	if [ "x$varname_env" = "x" ]; then
		if [ "x$varname_conf" = "x" ]; then
			if [ "x$varname_def" = "x" ]; then
				# No default; abort
				abort "Cannot find default value for ENV_VAR";
			else
				# Variable not set; use default
				env_var=$varname_def;
			fi
		else
			# Variable set in file / on runtime
			env_var=$varname_conf;
		fi
	else
		# Variable set in environment
		env_var=$varname_env;
	fi

	# Finally, update the original variable
	export $1=$env_var;
}

. $@;
