# Finish: final script to call on this stage

log "Stage 2 finished successfully";

rm stage2;

[ "$OOS_USE_REBOOT" = 1 ] && log "Rebooting..." && reboot;

exit;
