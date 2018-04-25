#
# 0.6. Aggregate
# Aggregates configurations from different sources to the final configuration
# that is going to be used in the installation process.
# The order of importance is as follows, from most important to least:
# 
# 1. Command-line defined environment variables ENV_VAR
# 2. Config file variables / custom set variables on runtime _ENV_VAR
# 3. Default variables ENV_VAR_DEFAULT
#

# TODO

ENV_VAR_DEFAULT="james";

if [ "x$ENV_VAR" = "x" ]; then
	if [ "x$_ENV_VAR" = "x" ]; then
		if [ "x$ENV_VAR_DEFAULT" = "x" ]; then
			# No default; abort
			abort "Cannot find default value for ENV_VAR";
		else
			# Variable not set; use default
			ENV_VAR=$ENV_VAR_DEFAULT;
		fi
	else
		# Variable set in file / on runtime
		ENV_VAR=$_ENV_VAR;
	fi
fi

debug "ENV_VAR=$ENV_VAR";

. $@;
