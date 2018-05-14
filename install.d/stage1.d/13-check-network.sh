# Check that we are connected, and check the network settings
# So that they can be used in the new installation

log "Checking network settings...";

oos_test_connection() {
	OOS_NETWORK_CONNECTION_TEST=5x.fi;
	curl -s "$OOS_NETWORK_CONNECTION_TEST" > /dev/null || abort "There doesn't seem to be any network connection." "Please check your network settings.";
}

oos_convert_to_variables() {
	file=$1;
	cat "$file" | grep = | awk -F= '{ if (!a[$1]++) { gsub("-","_",$1); print "export \"OOS_NETWORK_"toupper($1)"="$2"\"" } }';
}

oos_probe_nmcli() {
	debug "Probing nmcli...";
	
	# Get SSID
	ssid=$(oos_get_ssid_nmcli);
	debug "SSID: $ssid";

	[ -z "$ssid" ] && abort "We are connected to the internet, but cannot determine SSID!" "This is likely to be a bug. Sorry!";

	OOS_NETWORKMANAGER_PATH=/etc/NetworkManager/system-connections/;
	if [ -f "$OOS_NETWORKMANAGER_PATH/$ssid" ]; then
		oos_convert_to_variables "$OOS_NETWORKMANAGER_PATH/$ssid" >> "$OOS_INSTALL_CONF_PATH";
	else
		warning "Cannot predetermine network settings, those need to be input manually...";
	fi
}

oos_get_ssid_nmcli() {
	# Get the second line from nmcli active connections (nmcli prints a table header as the first line)
	nmcli connection show --active | awk '{ if (NR==2) print $1 }';
}

oos_probe_wpa_supplicant() {
	log "Probing wpa supplicant...";
	warning "Not supported yet";
}

oos_test_connection;

# Try to probe all the required settings (and a bit more) from the current network manager we use

# nmcli: /etc/NetworkManager/system-connections/#{id}
# wpa_supplicant: /etc/wpa_supplicant/*.conf

# TODO: Check whether we are using nmcli or wpa_supplicant or something else
oos_probe_nmcli;
#oos_probe_wpa_supplicant;


# Check which packages need to be installed
case "$OOS_NETWORK_DRIVER" in
	"wpa_supplicant")
		OOS_ADDITIONAL_PACKAGES="wpa_supplicant $OOS_ADDITIONAL_PACKAGES";
		;;
	[Nn]"etwork"[Mm]"anager"|nmcli)
		OOS_ADDITIONAL_PACKAGES="networkmanager $OOS_ADDITIONAL_PACKAGES";
		;;
	*)
		abort "Unknown network driver: $OOS_NETWORK_DRIVER!";
esac

. $@;
