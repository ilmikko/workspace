#
# Skeleton - Establishing the skeleton structure
# This section takes care of mounting the created partitions the first time,
# and creating necessary directories for pacstrap to work with.
#

#TODO: Can we use /mnt for this as well?

oos_get_root_partition() {
	# Get the partitions we have created
	created_partitions=($(oos_created_partitions));

	for (( i=0; i<${#OOS_PARTITIONS[@]}; i++ )) do
		split=(${OOS_PARTITIONS[$i]//:/ });

		mount=${split[2]};

		[[ $mount = / ]] && echo ${created_partitions[$i]} && return;
	done
}

# Inputs: $1 device, $2 mount folder
oos_mount() {
	mount_folder=$2;

	# Mount the root partition first, if it exists
	root_partition=$(oos_get_root_partition);
	mount "$root_partition" "$mount_folder";
}

log "Creating file structure skeleton...";

# Make a temporary folder for the files to reside in
OOS_MOUNT_FOLDER=$(mktemp --directory /tmp/oos_skeleton.XXXXXX);

# Mount the partitions, creating the directory tree
oos_mount $OOS_INSTALL_DEVICE $OOS_MOUNT_FOLDER;

# Next file
. $@;
