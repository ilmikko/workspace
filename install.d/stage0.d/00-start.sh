log "Checking installation stage...";

# TODO: Make this more sophisticated
[ -a "stage3" ] && OOS_STAGE=stage3 || OOS_STAGE=stage2;

. $@ $OOS_INSTALL_PATH/$OOS_STAGE.d/*;
