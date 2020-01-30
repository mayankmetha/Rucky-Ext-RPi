#!/bin/bash
apt update -y
apt upgrade -y
apt install dnsmasq hostapd -y
systemctl stop dnsmasq
systemctl stop hostapd
cat<<EOF > /etc/dhcpcd.conf
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF
service dhcpcd restart
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cat<<EOF > /etc/dnsmasq.conf
interface=wlan0 
dhcp-range=192.168.1.10,192.168.1.20,255.255.255.0,24h
EOF
systemctl start dnsmasq
cat<<EOF > /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=RUCKY
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
systemctl unmask hostapd
systemctl enable hostapd
systemctl start hostapd
systemctl status hostapd
systemctl status dnsmasq
reboot