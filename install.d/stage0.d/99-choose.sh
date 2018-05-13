log "Checking installation stage...";

# TODO: Make this more sophisticated
if [ -a "stage3" ]; then
	OOS_STAGE=stage3;
elif [ -a "stage2"]; then
	OOS_STAGE=stage2;
else
	OOS_STAGE=stage1;
fi

. $@ $OOS_INSTALL_PATH/$OOS_STAGE.d/*;
