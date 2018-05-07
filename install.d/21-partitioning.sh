oos_wipe() {
	log "Wiping $1...";
	wipefs -a $1;
}

oos_create_label() {
	device=$1;
	label=$2;
	file=$3;

	debug "Partition table label: $label";
	# TODO: find a fdisk solution
	parted $device --script mklabel $label
}

# Input: size
oos_create_partition() {
	file=$1;
	size=$2;
	(
		echo n # new partition
		echo # default number
		echo # default start sector
		if [ -z $size ]; then
			echo # use rest of space
		else
			echo +$size # use this much space
		fi
		#echo w # write to disk
	) >> $file;
}

oos_partition_execute() {
	device=$1;
	file=$2;
	echo w >> $file; # write
	cat $file | fdisk $device;
	rm $file;
}

oos_partition() {
	log "Partitioning disk...";
	device=$1;

	# We need this to concatenate fdisk commands into one!
	tempfile=$(mktemp /tmp/oos_fdisk.XXXXXX);

	oos_create_label $device $OOS_PARTITION_DISK_LABEL $tempfile;

	# Partition it according to our partition settings in OOS_PARTITIONS
	for (( i=0; i<${#OOS_PARTITIONS[@]}; i++ )) do
		part=(${OOS_PARTITIONS[$i]//:/ });

		bytes=${part[1]};
		bytes_human=$(from_bytes $bytes);

		if [ $i == $(( ${#OOS_PARTITIONS[@]} - 1 )) ]; then
			oos_create_partition $tempfile;
		else
			oos_create_partition $tempfile $bytes_human;
		fi
	done

	oos_partition_execute $device $tempfile;
}

# TODO: There needs to be a sanity check that mkfs.$filesystem exists before we install!
oos_create_fs() {
	fs_type=$1;
	partition=$2;

	case $fs_type in
		"fat32")
			mkfs.fat -F32 $partition;
			#fatlabel $label;
			;;
		"swap")
			mkswap $partition;
			#swaplabel $label;
			;;
		"ext4"|"ext3"|"ext2")
			mkfs.$fs_type -F $partition;
			#e2label $label;
		*)
			yes | mkfs.$fs_type $partition;
			;;
	esac
}

oos_create_filesystems() {
	device=$1;

	# Get the partitions we just created
	partitions=($(fdisk -l /dev/sdb | awk '/^\/dev/ { print $1 }'));

	log "Creating filesystems...";
	for (( i=0; i<${#OOS_PARTITIONS[@]}; i++ )) do
		part=(${OOS_PARTITIONS[$i]//:/ });

		filesystem=${part[3]};
		partition=${partitions[$i]};

		debug "Create fs $filesystem on $partition";
		oos_create_fs $filesystem $partition;
	done
}

# Wipe the device
oos_wipe $OOS_INSTALL_DEVICE;

# Partition the device
oos_partition $OOS_INSTALL_DEVICE;

# Make the filesystems
oos_create_filesystems $OOS_INSTALL_DEVICE;

# Mount the partitions, create the directory tree
#oos_mount $OOS_INSTALL_DEVICE;

