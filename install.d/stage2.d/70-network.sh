# Generate network configs based on driver

log "Generating network configurations...";

if [ -z "$OOS_NETWORK_CONFIG_PHASE2" ] && [ ! -z "$OOS_NETWORK_CONFIG_PHASE2_AUTH" ]; then
	# Use $OOS_NETWORK_CONFIG_PHASE2_AUTH if it is defined

	# Convert to uppercase
	OOS_NETWORK_CONFIG_PHASE2_AUTH=$(echo $OOS_NETWORK_CONFIG_PHASE2_AUTH | awk '{ print toupper($0) }');
	OOS_NETWORK_CONFIG_PHASE2="auth=$OOS_NETWORK_CONFIG_PHASE2_AUTH";
fi

config_include_property() {
	key=$1;
	value=$2;
	file=$3;

	# No need to include a value that is empty, right?
	[ -z "$value" ] || echo "$key=$value" >> "$file";
}

# TODO: Redundant
config_include_property_sq() {
	key=$1;
	value=$2;
	file=$3;

	# These four spaces in the front are important
	[ -z "$value" ] || echo "    '$key=$value'" >> "$file";
}

oos_strip_property() {
	echo "$@" | awk '{ sub(";$","",$0); print toupper($0); }';
}

wrap_in_singles() {
	[ -z "$@" ] || echo "'$@'";
}

wrap_in_doubles() {
	[ -z "$@" ] || echo \"$@\";
}

case "$OOS_NETWORK_DRIVER" in
	"wpa_supplicant")
		file=$OOS_ROOT_FOLDER/etc/wpa_supplicant/wpa_supplicant.conf
		mkdir -p "$(dirname $file)";
		echo "network={" > "$file";
		config_include_property ssid "$(wrap_in_doubles $OOS_NETWORK_CONFIG_SSID)" "$file";
		config_include_property key_mgmt "$(oos_strip_property $OOS_NETWORK_CONFIG_KEY_MGMT)" "$file";
		config_include_property eap "$(oos_strip_property $OOS_NETWORK_CONFIG_EAP)" "$file";
		config_include_property group "$OOS_NETWORK_CONFIG_GROUP" "$file";
		config_include_property pairwise "$OOS_NETWORK_CONFIG_PAIRWISE" "$file";
		config_include_property anonymous_identity "$(wrap_in_doubles $OOS_NETWORK_CONFIG_ANONYMOUS_IDENTITY)" "$file";
		config_include_property identity "$(wrap_in_doubles $OOS_NETWORK_CONFIG_IDENTITY)" "$file";
		config_include_property password "$(wrap_in_doubles $OOS_NETWORK_CONFIG_PASSWORD)" "$file";
		config_include_property priority "$OOS_NETWORK_CONFIG_PRIORITY" "$file";
		config_include_property phase1 "$(wrap_in_doubles $OOS_NETWORK_CONFIG_PHASE1)" "$file";
		config_include_property phase2 "$(wrap_in_doubles $OOS_NETWORK_CONFIG_PHASE2)" "$file";
		echo "}" >> "$file";
		;;
	"netctl")
		file="$OOS_ROOT_FOLDER/etc/netctl/$OOS_NETWORK_CONFIG_SSID";
		mkdir -p "$(dirname $file)";
	
		echo "Description='A setup connection'" > "$file";
		echo "Interface=" >> "$file"; # This will be filled later on, before connection
		echo "Connection=wireless" >> "$file";
		echo "Security=wpa-configsection" >> "$file";
		echo "IP=dhcp" >> "$file";
		echo "WPAConfigSection=(" >> "$file";
		config_include_property_sq ssid "$(wrap_in_doubles $OOS_NETWORK_CONFIG_SSID)" "$file";
		config_include_property_sq key_mgmt "$(oos_strip_property $OOS_NETWORK_CONFIG_KEY_MGMT)" "$file";
		config_include_property_sq eap "$(oos_strip_property $OOS_NETWORK_CONFIG_EAP)" "$file";
		config_include_property_sq group "$OOS_NETWORK_CONFIG_GROUP" "$file";
		config_include_property_sq pairwise "$OOS_NETWORK_CONFIG_PAIRWISE" "$file";
		config_include_property_sq anonymous_identity "$(wrap_in_doubles $OOS_NETWORK_CONFIG_ANONYMOUS_IDENTITY)" "$file";
		config_include_property_sq identity "$(wrap_in_doubles $OOS_NETWORK_CONFIG_IDENTITY)" "$file";
		config_include_property_sq password "$(wrap_in_doubles $OOS_NETWORK_CONFIG_PASSWORD)" "$file";
		config_include_property_sq priority "$OOS_NETWORK_CONFIG_PRIORITY" "$file";
		config_include_property_sq phase1 "$(wrap_in_doubles $OOS_NETWORK_CONFIG_PHASE1)" "$file";
		config_include_property_sq phase2 "$(wrap_in_doubles $OOS_NETWORK_CONFIG_PHASE2)" "$file";
		echo ")" >> "$file";
		;;
	"networkmanager")
		file="$OOS_ROOT_FOLDER/etc/NetworkManager/system-connections/$OOS_NETWORK_CONFIG_SSID";
		mkdir -p "$(dirname $file)";

		echo "[connection]" > "$file";
		config_include_property id "$OOS_NETWORK_CONFIG_SSID" "$file";
		config_include_property uuid "$OOS_NETWORK_CONFIG_UUID" "$file";
		config_include_property type "$OOS_NETWORK_CONFIG_TYPE" "$file";
		config_include_property permissions "$OOS_NETWORK_CONFIG_PERMISSIONS" "$file";
		echo >> "$file";
		echo "[wifi]" >> "$file";
		config_include_property ssid "$OOS_NETWORK_CONFIG_SSID" "$file";
		echo >> "$file";
		echo "[wifi-security]" >> "$file";
		config_include_property key-mgmt "$OOS_NETWORK_CONFIG_KEY_MGMT" "$file";
		echo >> "$file";
		echo "[802-1x]" >> "$file";
		config_include_property "ca-cert" "$OOS_NETWORK_CONFIG_CA_CERT" "$file";
		config_include_property eap "$OOS_NETWORK_CONFIG_EAP" "$file";
		config_include_property identity "$OOS_NETWORK_CONFIG_IDENTITY" "$file";
		config_include_property password "$OOS_NETWORK_CONFIG_PASSWORD" "$file";
		config_include_property "phase2-auth" "$OOS_NETWORK_CONFIG_PHASE2_AUTH" "$file";
		echo >> "$file";
		echo "[ipv4]" >> "$file";
		config_include_property "dns-search" "$OOS_NETWORK_CONFIG_DNS_SEARCH" "$file";
		config_include_property "method" "$OOS_NETWORK_CONFIG_METHOD" "$file";
		echo >> "$file";
		echo "[ipv6]" >> "$file";
		config_include_property "addr-gen-mode" "$OOS_NETWORK_CONFIG_ADDR_GEN_MODE" "$file";
		config_include_property "dns-search" "$OOS_NETWORK_CONFIG_DNS_SEARCH" "$file";
		config_include_property "method" "$OOS_NETWORK_CONFIG_METHOD" "$file";
		;;
	*)
		warning "Failed to generate network configurations for driver $OOS_NETWORK_DRIVER!";
		;;
esac

. $@;
