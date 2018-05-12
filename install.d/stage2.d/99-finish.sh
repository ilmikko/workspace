# Finish: final script to call on this stage

log "Stage 2 finished successfully";

[ "$OOS_USE_REBOOT" = 1 ] && log "Rebooting..." && reboot;

exit;
