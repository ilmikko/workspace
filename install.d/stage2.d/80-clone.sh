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

getty_folder=/etc/systemd/system/getty@tty1.service.d/;

# Make the installation autologin into root
log "Configuring first time setup...";
debug "Service files";
mkdir -p $OOS_ROOT_FOLDER/$getty_folder/;
file=$OOS_ROOT_FOLDER/$getty_folder/override.conf;
echo "[Service]" > $file;
echo "ExecStart=" >> $file;
echo "ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM" >> $file;

debug "Root login file";
# Make root automatically run stage 3
echo "bash $OOS_ROOT_FOLDER/$OOS_CLONE_FOLDER/install.sh" > $OOS_ROOT_FOLDER/root/.profile;

. $@;
