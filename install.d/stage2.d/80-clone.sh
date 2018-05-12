# 
# 8. Clone
# Clone the installation script onto the mounted folder and make it autorun on boot
#

# TODO: Do we need to clone stage 1 and 2 for this?
log "Copying installation over...";
cp -rv ./ $OOS_ROOT_FOLDER/root;

# Make the installation autologin into stage 3
log "Configuring first time setup...";
getty_folder=/etc/systemd/system/getty@tty1.service.d/;
mkdir -p $OOS_ROOT_FOLDER/$getty_folder/;
echo "[Service]" > $OOS_ROOT_FOLDER/$getty_folder/override.conf;
echo "ExecStart=-/usr/bin/bash $0 --autologin root --noclear %I $TERM" >> $OOS_ROOT_FOLDER/$getty_folder/override.conf;

. $@;
