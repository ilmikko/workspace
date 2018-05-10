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

# aggregate installation configs
aggregate_variable "OOS_FASTTRACK";
OOS_ERROR_TIMEOUT_DEFAULT=1 && aggregate_variable "OOS_ERROR_TIMEOUT";

# Installation steps
OOS_USE_PARTITIONING_DEFAULT=1 && aggregate_variable "OOS_USE_PARTITIONING";

# aggregate_variable "ENV_VAR"
aggregate_variable "OOS_INSTALL_DEVICE";

# aggregate partitions
aggregate_variable "OOS_PARTITION_LIST";
OOS_PARTITION_DISK_LABEL_DEFAULT="gpt" && aggregate_variable "OOS_PARTITION_DISK_LABEL";

# packages
OOS_DEFAULT_PACKAGES_DEFAULT="base base-devel vim dialog wifi-menu" && aggregate_variable "OOS_DEFAULT_PACKAGES_DEFAULT";
aggregate_variable "OOS_INSTALL_PACKAGES";

# hosts
OOS_HOSTNAME_DEFAULT="Installation $(date "+%Y-%M-%d")" && aggregate_variable "OOS_HOSTNAME";

# locale
OOS_LANG_DEFAULT="en_US.UTF-8" && aggregate_variable "OOS_LANG";
OOS_LOCALE_DEFAULT="en_US" && aggregate_variable "OOS_LOCALE";

. $@;
