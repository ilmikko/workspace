oos_wipe() {
	log "Wiping $1...";
	until wipefs -a $1; do warning "Wiping failed; trying again..."; sleep 1; done;
}

oos_create_label() {
	device=$1;
	label=$2;
	file=$3;

	debug "Partition table label: $label";
	case $label in
		[Gg][Pp][Tt])
			key=g;
			;;
		[Dd][Oo][Ss]|[Mm][Bb][Rr])
			key=o;
			;;
		[Ss][Uu][Nn])
			key=s;
			;;
		[Ss][Gg][Ii]|[Ii][Rr][Ii][Xx])
			key=G;
			;;
		*)
			abort "Unknown partition table label: $label";
			;;
	esac
	#parted $device --script mklabel $label || return;
	echo $key > $file; # Should be the first command, so single > is fine
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

	until oos_partition_execute $device $tempfile; do warning "Failed to partition disk, trying again..."; sleep 1; done;
}

# TODO: There needs to be a sanity check that mkfs.$filesystem exists before we install!
oos_create_fs() {
	partition=$1;
	fs_type=$2;
	label=$3;

	# Unmount and wipe in case there are previous signatures in the partition
	oos_umount $partition && oos_wipe $partition || return;

	case $fs_type in
		[Ff][Aa][Tt]32)
			mkfs.fat -F32 $partition && fatlabel $partition $label || return;
			;;
		[Ss][Ww][Aa][Pp])
			mkswap $partition && swaplabel $partition --label $label || return;
			;;
		[Ee][Xx][Tt][234])
			mkfs.$fs_type -F $partition && e2label $partition $label || return;
			;;
		*)
			yes | mkfs.$fs_type $partition;
			;;
	esac
}

oos_created_partitions() {
	fdisk -l $OOS_INSTALL_DEVICE | awk '/^\/dev/ { print $1 }';
}

oos_create_filesystems() {
	device=$1;

	# Get the partitions we just created
	partitions=($(oos_created_partitions));

	log "Creating filesystems...";
	for (( ii=0; ii<${#OOS_PARTITIONS[@]}; ii++ )) do
		part=(${OOS_PARTITIONS[$ii]//:/ });

		filesystem=${part[3]};
		label=${part[0]};
		partition=${partitions[$ii]};

		debug "Create fs $filesystem on $partition";
		# Keep doing until successful
		until oos_create_fs $partition $filesystem $label; do warning "Filesystem creation on $partition failed; trying again..."; sleep 1; done;
	done
};

if [ "$OOS_USE_PARTITIONING" != 1 ]; then
	warning "Skipping partitioning step...";
	. $@;
	exit;
fi

# Wipe the device
oos_wipe $OOS_INSTALL_DEVICE;

# Partition the device
oos_partition $OOS_INSTALL_DEVICE;

# Make the filesystems
oos_create_filesystems $OOS_INSTALL_DEVICE;

. $@;
