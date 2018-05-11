# Finish: final script to call on this stage

log "Stage 2 finished successfully";
log "Rebooting...";

[ "$OOS_USE_REBOOT" = 1 ] && reboot;

exit;
