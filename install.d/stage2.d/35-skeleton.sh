#
# Load (Phase 2) skeleton files after strapping the programs
#

if [ "$OOS_USE_SKELETON" != 1 ]; then
	warning "Skipping skeleton step...";
	. $@;
	exit;
fi

log "Loading skeleton files...";

for skeleton in $OOS_SKELETON_PATH/*; do
	debug "Skeleton $skeleton...";
	cp -rv $skeleton/* $OOS_ROOT_FOLDER;
done

. $@;
