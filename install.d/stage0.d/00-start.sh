log "Checking installation stage...";

OOS_STAGE=stage2;

. $@ $OOS_INSTALL_PATH/$OOS_STAGE.d/*;
