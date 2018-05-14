# Check that we are connected, and check the network settings
# So that they can be used in the new installation

log "Checking network settings...";

oos_test_connection() {
	OOS_NETWORK_CONNECTION_TEST=5x.fi;
	curl -s "$OOS_NETWORK_CONNECTION_TEST" > /dev/null || abort "There doesn't seem to be any network connection." "Please check your network settings.";
}

oos_nmcli_to_variables() {
	# Convert network manager's config file into environment variables
	file=$1;
	cat "$file" | grep = | awk -F= '{ if (!a[$1]++) { gsub("-","_",$1); print "export \"OOS_NETWORK_CONFIG_"toupper($1)"="$2"\"" } }';
}

oos_wpa_to_variables() {
	file=$1;
	cat $file | awk -F= 'BEGIN { t=!!t; } { if ($1=="}") t=!t; if (t) print $0; if ($1=="network") t=!t; }' | awk -F= '{ gsub("-","_",$1); gsub("^[\"'\'']|[\"'\'']$","",$2); print "export \"OOS_NETWORK_CONFIG_"toupper($1)"="$2"\"" }'
}

oos_netctl_to_variables() {
	file=$1;

	# If we have phase2 with auth=, deal with it separately as we only need PHASE2_AUTH
	PHASE2_AUTH=$(cat $file | awk -F= '{ print toupper($1)"="$2"="$3 }' | awk -F= '/PHASE2/ { gsub("^[\"\x27]*|[\"\x27]*$","",$2); if (toupper($2)=="AUTH") { gsub("^[\"\x27]*|[\"\x27]*$","",$3); print $3 } }');
	[ -z "$PHASE2_AUTH" ] || echo "export \"OOS_NETWORK_CONFIG_PHASE2_AUTH=$PHASE2_AUTH\"";

	cat $file | awk -F= 'BEGIN { OFS=FS } { gsub("^[\"\x27]*|[\"\x27]*$","",$2); gsub("[\"\x27]*$","",$0); if ($2) { gsub("-","_",$1); sub("^.*\x27","",$1); $1=toupper($1); print $0; } }' | awk -F= 'BEGIN { OFS=FS } { gsub("\"","",$2); gsub("\"","",$0); print "export \"OOS_NETWORK_CONFIG_"$0"\""; }';
}

oos_probe_nmcli() {
	debug "Probing nmcli...";
	
	# Get SSID
	ssid=$(oos_get_ssid_nmcli);
	debug "SSID: $ssid";

	[ -z "$ssid" ] && abort "We are connected to the internet, but cannot determine SSID!" "This is likely to be a bug. Sorry!";

	OOS_NETWORKMANAGER_PATH=/etc/NetworkManager/system-connections/;
	if [ -f "$OOS_NETWORKMANAGER_PATH/$ssid" ]; then
		oos_nmcli_to_variables "$OOS_NETWORKMANAGER_PATH/$ssid" >> "$OOS_INSTALL_CONF_PATH";
	else
		warning "Cannot predetermine network settings, those need to be input manually...";
	fi
}

oos_get_ssid_nmcli() {
	# Get the second line from nmcli active connections (nmcli prints a table header as the first line)
	nmcli connection show --active | awk '{ if (NR==2) print $1 }';
}

oos_probe_netctl() {
	debug "Probing netctl...";

	# Get SSID
	ssid=$(netctl list | awk '/^*/ { print $2 }');
	debug "SSID: $ssid";

	[ -z "$ssid" ] && abort "We are connected to the internet, but cannot determine SSID!" "This is likely due to a bug. Sorry!";

	OOS_NETCTL_PATH=/etc/netctl/;
	if [ -f "$OOS_NETCTL_PATH/$ssid" ]; then
		oos_netctl_to_variables "$OOS_NETCTL_PATH/$ssid" >> "$OOS_INSTALL_CONF_PATH";
	else
		warning "Cannot predetermine network settings, those need to be input manually...";
	fi
}

oos_probe_wpa_supplicant() {
	debug "Probing wpa supplicant...";

	OOS_WPA_SUPPLICANT_PATH=/etc/wpa_supplicant/wpa_supplicant.conf;
	if [ -f "$OOS_WPA_SUPPLICANT_PATH" ]; then
		oos_wpa_to_variables "$OOS_WPA_SUPPLICANT_PATH" >> "$OOS_INSTALL_CONF_PATH";
	else
		warning "Cannot predetermine network settings, those need to be input manually...";
	fi
}

oos_is_running(){
	proc=$1;
	empty=$(ps aux | grep -m 1 "$proc" | grep -v grep)
	[ ! -z "$empty" ];
}

oos_probe_network_driver() {
	if oos_is_running NetworkManager; then
		echo "NetworkManager is running!";
		oos_probe_nmcli;
	elif oos_is_running netctl; then
		echo "Netctl is running!";
		oos_probe_netctl;
	elif oos_is_running wpa_supplicant; then
		echo "wpa_supplicant is running!";
		oos_probe_wpa_supplicant;
	else
		warning "Current network probing failed.";
	fi
}

oos_test_connection;

# Try to probe all the required settings (and a bit more) from the current network manager we use
oos_probe_network_driver;


# Check which packages need to be installed
case "$OOS_NETWORK_DRIVER" in
	"wpa_supplicant")
		OOS_ADDITIONAL_PACKAGES="wpa_supplicant $OOS_ADDITIONAL_PACKAGES";
		;;
	"networkmanager")
		OOS_ADDITIONAL_PACKAGES="networkmanager $OOS_ADDITIONAL_PACKAGES";
		;;
	"netctl")
		OOS_ADDITIONAL_PACKAGES="$OOS_ADDITIONAL_PACKAGES";
		;;
	*)
		abort "Unknown network driver: $OOS_NETWORK_DRIVER!";
		;;
esac

# We need this again in stage 3
export_config 'OOS_NETWORK_DRIVER';

. $@;
