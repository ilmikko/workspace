# Connect to the network on the new machine

log "Connecting to $OOS_NETWORK_CONFIG_SSID...";

oos_connectivity_check() {
	OOS_NETWORK_CONNECTION_TEST=5x.fi;
	curl -s "$OOS_NETWORK_CONNECTION_TEST" > /dev/null
}

oos_get_wireless_interface() {
	ls /sys/class/net | grep -m 1 wl;
}

case "$OOS_NETWORK_DRIVER" in
	"wpa_supplicant")
		# The configuration file lies in /etc/wpa_supplicant/wpa_supplicant.conf
		# We should be good to go just by enabling the services
		systemctl disable netctl;
		systemctl stop netctl;

		# Get the wireless interface
		interface=$(oos_get_wireless_interface);

		systemctl enable wpa_supplicant@$interface.service;
		systemctl restart wpa_supplicant@$interface.service;
		systemctl enable dhcpcd.service;
		systemctl restart dhcpcd.service;
		;;
	"netctl")
		# We need to get the interface now that we're here, and append that to the configuration file.
		# Then we can enable the services.

		interface=$(oos_get_wireless_interface);

		file="/etc/netctl/$OOS_NETWORK_CONFIG_SSID";
		if [ ! -f "$file" ]; then
			warning "Cannot find network file... trying to probe the file manually.";
			# Do some magic with "netctl list"
		fi
		cat "$file" | sed 's/Interface=.*/Interface='$interface'/' > "$file";

		# Enable the services
		systemctl enable netctl;
		systemctl restart netctl;
		netctl restart "$OOS_NETWORK_CONFIG_SSID";
		;;
	*)
		error "TODO!";
		;;
esac

until oos_connectivity_check; do
	debug "Waiting for us to go online...";
	sleep 2;
done

log "Huzzah, we're online!";
