# Connect to the network on the new machine

log "Connecting to $OOS_NETWORK_CONFIG_SSID...";

oos_connectivity_check() {
	OOS_NETWORK_CONNECTION_TEST=5x.fi;
	curl -s "$OOS_NETWORK_CONNECTION_TEST" > /dev/null
}

case "$OOS_NETWORK_DRIVER" in
	"wpa_supplicant")
		# The configuration file lies in /etc/wpa_supplicant/wpa_supplicant.conf
		# We should be good to go just by enabling the services
		systemctl disable netctl;
		systemctl stop netctl;

		systemctl enable wpa_supplicant;
		systemctl enable dhcpcd;
		systemctl restart wpa_supplicant;
		systemctl restart dhcpcd;

		until oos_connectivity_check; do
			debug "Waiting for us to go online...";
			sleep 1;
		done

		log "Hooray, we're online!";

		;;
	*)
		error "TODO!";
		;;
esac
