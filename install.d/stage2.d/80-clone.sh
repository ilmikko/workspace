# 
# 8. Clone
# Clone the installation script onto the mounted folder and make it autorun on boot
#

# where to clone the script into the new installation
OOS_CLONE_FOLDER=/root;

# TODO: Do we need to clone stage 1 and 2 for this?
log "Copying installation over...";
cp -rv ./* $OOS_ROOT_FOLDER/$OOS_CLONE_FOLDER;
# Make the script know it's in stage 3
touch $OOS_ROOT_FOLDER/$OOS_CLONE_FOLDER/stage3;

# Make the installation autologin into stage 3
log "Configuring first time setup...";
getty_folder=/etc/systemd/system/getty@tty1.service.d/;
mkdir -p $OOS_ROOT_FOLDER/$getty_folder/;
echo "[Service]" > $OOS_ROOT_FOLDER/$getty_folder/override.conf;
echo "ExecStart=-/usr/bin/bash /$OOS_CLONE_FOLDER/$0" >> $OOS_ROOT_FOLDER/$getty_folder/override.conf;

. $@;
