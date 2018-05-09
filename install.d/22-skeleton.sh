#
# Skeleton - Establishing the skeleton structure
# This section takes care of mounting the created partitions the first time,
# and creating necessary directories for pacstrap to work with.
#

#TODO: Can we use /mnt for this as well?

oos_get_root_partition() {
	# Get the partitions we have created
	created_partitions=($@);
	
	for (( i=0; i<${#OOS_PARTITIONS[@]}; i++ )) do
		split=(${OOS_PARTITIONS[$i]//:/ });

		mount=${split[2]};

		[ "$mount" = / ] && echo ${created_partitions[$i]} && return;
	done

	# No root partition
	return;
}

oos_get_swap_partitions() {
	# Get the partitions we have created
	created_partitions=($@);

	for (( i=0; i<${#OOS_PARTITIONS[@]}; i++ )) do
		split=(${OOS_PARTITIONS[$i]//:/ });

		fs_type=${split[3]};

		[ $fs_type = swap ] && echo ${created_partitions[$i]} && return;
	done
}

# Inputs: $1 device, $2 mount folder
oos_mount_all() {
	mount_folder=$2;

	# TODO: Use this in subsequent calls
	created_partitions=($(oos_created_partitions));

	# Mount the root partition first, if it exists
	root_partition=$(oos_get_root_partition ${created_partitions[@]});
	if ! [ -z "$root_partition" ]; then
		log "Mount $root_partition on / ($mount_folder)";
		mount "$root_partition" "$mount_folder";
	fi

	# Mount the swap partition(s) if any exist
	swap_partitions=($(oos_get_swap_partitions ${created_partitions[@]}));
	for (( i=0; i<${#swap_partitions[@]}; i++ )) do
		partition=${swap_partitions[$i]};
		debug "Enabling swap for $partition";
		swapon $partition;
	done

	mounted_remaining="";
	# Get all the partitions whose dirname is / (except for the root partition), and put them in a "remaining" list
	# This is because we want to mount the first level items first. If there are mountings inside mountings,
	# those need to be mounted after their parent devices have been mounted as well.
	# The partitions that are provided are not necessarily in order; that is why we need a variable to keep track of
	# all the remaining partitions we need to mount.
	# Swap is also ignored here, depicted by 'none'. 'none' can also be used to not mount some partitions
	for (( i=0; i<${#OOS_PARTITIONS[@]}; i++ )) do
		split=(${OOS_PARTITIONS[$i]//:/ });

		mount=${split[2]};
		# Skip partitions that should not be mounted here
		[ $mount = / ] || [ $mount = none ] && continue;

		mount=$mount_folder/$mount;

		# Check if the dirname of this partition mount point is /, in which case we can create the required folder and mount it

		# If the dirname is not /, we need to process this later, so we add it to the list
		mounted_remaining=(${mounted_remaining[@]} ${created_partitions[$i]}:$mount:$mount);
	done

	level=0;
	while true; do
		# Keep progressing up the file structure until every dirname is /
		for (( i=0; i<${#mounted_remaining[@]}; i++ )) do
			split=(${mounted_remaining[$i]//:/ });

			device=${split[0]};
			mount=${split[1]};
			path=${split[2]};

			dir=$(dirname $path);

			if [ $dir != / ]; then
				# Update for next loop
				mounted_remaining[$i]=$device:$mount:$dir;
			else
				# Dir is /; this means that we can create some directories
				warning "Create directory $mount and mount $device on it";
				mkdir -p $mount;
				log "Mount $device on ($mount)";
				mount $device $mount;
				# Update to be ignored (dirname of . is always .)
				mounted_remaining[$i]=$device:$mount:.;
			fi
		done

		# Check if all the paths are . already, in which case we can break
		path_list=$(printf "%s\n" ${mounted_remaining[@]} | awk -F':' '{ sub("\\.","",$3); print $3 }');
		[ -z "$path_list" ] && break;
	done
}

# TODO: How are we supposed to know where to install then, we need a mounting folder
OOS_USE_MOUNTING=1;
if [ "$OOS_USE_MOUNTING" != 1 ]; then
	warning "Skipping mounting step...";
	. $@;
	exit;
fi

log "Creating file structure skeleton...";

# Make a temporary folder for the files to reside in
OOS_MOUNT_FOLDER=$(mktemp --directory /tmp/oos_skeleton.XXXXXX);

# Mount the partitions, creating the directory tree
oos_mount_all $OOS_INSTALL_DEVICE $OOS_MOUNT_FOLDER;

# Next file
. $@;
