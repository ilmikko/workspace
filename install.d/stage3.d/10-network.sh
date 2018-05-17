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
		cat "$file" | sed 's/Interface=.*/Interface='$interface'/' > "$file.temp";
		mv "$file.temp" "$file";

		# Enable the services
		systemctl enable netctl;
		systemctl restart netctl;
		netctl restart "$OOS_NETWORK_CONFIG_SSID";
		;;
	"networkmanager")
		systemctl disable netctl;
		systemctl stop netctl;

		interface=$(oos_get_wireless_interface);

		systemctl disable netctl;
		systemctl stop netctl;

		interface=$(oos_get_wireless_interface);

		items="wifi-sec.key-mgmt:KEY_MGMT 802-1x.eap:EAP 802-1x.identity:IDENTITY 802-1x.ca-cert:CA_CERT 802-1x.password:PASSWORD 802-1x.phase2-auth:PHASE2_AUTH 802-1x.client-cert:CLIENT_CERT 802-1x.private-key:PRIVATE_KEY 802-1x.private-key-password:PRIVATE_KEY_PASSWORD";
		constr="";
		for item in $items; do
						convert=(${item/:/ });

						from=${convert[0]};
						to=OOS_NETWORK_CONFIG_${convert[1]};

						# Convert to value
						to=$(eval echo \$$to);

						[ -z "$to" ] && continue;
						constr=$from\ $to\ $constr;
		done

		nmcli connection down "$OOS_NETWORK_CONFIG_ID" 2>/dev/null;
		nmcli connection delete "$OOS_NETWORK_CONFIG_ID" 2>/dev/null;
		nmcli connection add type "$OOS_NETWORK_CONFIG_TYPE" con-name "$OOS_NETWORK_CONFIG_ID" ifname "$interface" ssid "$OOS_NETWORK_CONFIG_SSID" -- $constr;
		nmcli connection up "$OOS_NETWORK_CONFIG_ID";
		;;
	*)
		error "Cannot connect to the internet - invalid network driver!" "This is most likely due to a bug. Sorry!";
		;;
esac

until oos_connectivity_check; do
	debug "Waiting for us to go online...";
	sleep 2;
done

log "Huzzah, we're online!";
. $@;
