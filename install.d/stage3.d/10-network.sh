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

		# Get the wireless interface
		interface=$(ls /sys/class/net | grep -m 1 wl);

		systemctl enable wpa_supplicant@$interface.service;
		systemctl restart wpa_supplicant@$interface.service;
		systemctl enable dhcpcd.service;
		systemctl restart dhcpcd.service;

		until oos_connectivity_check; do
			debug "Waiting for us to go online...";
			sleep 2;
		done

		log "Huzzah, we're online!";

		;;
	*)
		error "TODO!";
		;;
esac
