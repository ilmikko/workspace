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

# aggregate_variable "ENV_VAR"
aggregate_variable "OOS_INSTALL_DEVICE";

# aggregate partitions
aggregate_variable "OOS_PARTITION_LIST";
OOS_PARTITION_DISK_LABEL_DEFAULT="gpt" && aggregate_variable "OOS_PARTITION_DISK_LABEL";

. $@;
