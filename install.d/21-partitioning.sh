oos_wipe() {
	echo "Wiping $1...";
	wipefs -a $1;
}

oos_create_label() {
	debug "Partition table label: $OOS_PARTITION_DISK_LABEL";
	# TODO: find a fdisk solution
	parted $OOS_INSTALL_DEVICE --script mklabel $OOS_PARTITION_DISK_LABEL
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
	file=$1;
	echo w >> $file; # write
	cat $file | fdisk $OOS_INSTALL_DEVICE;
	rm $file;
}

oos_partition() {
	echo "Partitioning disk...";

	# We need this to concatenate fdisk commands into one!
	tempfile=$(mktemp /tmp/oos_fdisk.XXXXXX);

	oos_create_label $tempfile;

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

	oos_partition_execute $tempfile;
}

# Wipe the device
oos_wipe $OOS_INSTALL_DEVICE;

# Partition the device
oos_partition $OOS_INSTALL_DEVICE;

# Make the filesystems
#oos_create_fs $OOS_INSTALL_DEVICE;

# Mount the partitions, create the directory tree
#oos_mount $OOS_INSTALL_DEVICE;

