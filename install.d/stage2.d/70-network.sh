# Generate network configs based on driver

log "Generating network configurations...";

case "$OOS_NETWORK_DRIVER" in
	"wpa_supplicant")
		file=$OOS_ROOT_FOLDER/etc/wpa_supplicant/wpa_supplicant.conf
		mkdir -p $(dirname $file);
		echo "network={" > $file;
		echo "ssid=\"$OOS_NETWORK_CONFIG_SSID\"" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_KEY_MGMT" ] && echo "key_mgmt=$OOS_NETWORK_CONFIG_KEY_MGMT" | awk -F= '{ sub(";$","",$2); print $1"="toupper($2) }' >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_PROTO" ] && echo "proto=$OOS_NETWORK_CONFIG_PROTO" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_PAIRWISE" ] && echo "pairwise=$OOS_NETWORK_CONFIG_PAIRWISE" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_EAP" ] && echo "eap=$OOS_NETWORK_CONFIG_EAP" | awk -F= '{ sub(";$","",$2); print $1"="toupper($2) }' >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_IDENTITY" ] && echo "identity=\"$OOS_NETWORK_CONFIG_IDENTITY\"" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_ANONYMOUS_IDENTITY" ] && echo "anonymous_identity=\"$OOS_NETWORK_CONFIG_ANONYMOUS_IDENTITY\"" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_PASSWORD" ] && echo "password=\"$OOS_NETWORK_CONFIG_PASSWORD\"" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_CA_CERT" ] && echo "ca_cert=\"$OOS_NETWORK_CONFIG_CA_CERT\"" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_PHASE1" ] && echo "phase1=\"$OOS_NETWORK_CONFIG_PHASE1\"" >> $file;
		[ ! -z "$OOS_NETWORK_CONFIG_PHASE2" ] && echo "phase2=\"$OOS_NETWORK_CONFIG_PHASE2\"" >> $file;
		echo "}" >> $file;
		;;
	*)
		warning "Failed to generate network configurations for driver $OOS_NETWORK_DRIVER!";
		;;
esac

. $@;
