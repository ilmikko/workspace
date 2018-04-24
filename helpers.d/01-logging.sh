# Various logging utilities

function error(){
	echo "[31mError: $@[m";
}
function warning(){
	echo "[33mWarning: $@[m";
}
function debug(){
	echo "[34mDebug: $@[m";
}

. $@;
