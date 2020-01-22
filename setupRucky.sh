echo "dtoverlay=dwc2" >> /boot/config.txt
echo "dwc" >> /etc/modules
echo "libcomposite" >> /etc/modules
sed -i '/^exit 0$/i \
/usr/bin/hidg0
/usr/rucky/setwlan.sh
' /etc/rc.local
cat <<EOF > /usr/bin/hidg0
#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p ruckyHID
cd ruckyHID
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
mkdir -p strings/0x409
echo "fedcba9876543210" > strings/0x409/serialnumber
echo "Mayank Metha D" > strings/0x409/manufacturer
echo "Rucky" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
# Add functions here
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 8 > functions/hid.usb0/report_length
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 > functions/hid.usb0/report_desc
ln -s functions/hid.usb0 configs/c.1/
# End functions
ls /sys/class/udc > UDC
#fix hidg0 permission
chmod +x /dev/hidg0
EOF
chmod +x /usr/bin/hidg0
apt update
apt upgrade -y
apt install -y hostapd dnsmasq
mkdir /usr/rucky
cat <<EOF > /usr/rucky/hostapd.cfg
interface=wlan0
ssid=RUCKY
channel=1
driver=nl80211
EOF
cat <<EOF > /usr/rucky/dnsmasq.cfg
interface=wlan0
dhcp-range=192.168.1.10,192.168.1.20,255.255.255.0,8h
dhcp-option=3,192.168.1.1
dhcp-option=6,192.168.1.1
address=/#/192.168.1.1
EOF
cat <<EOF > /usr/rucky/setwlan.sh
ifconfig wlan0 down
hostapd -B /usr/rucky/hostapd.cfg
dnsmasq -C /usr/rucky/dnsmasq.cfg
ifconfig wlan0 up
ifconfig wlan0 192.168.1.1 netmask 255.255.255.0
EOF
chmod +x /usr/rucky/setwlan.sh
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.cong.bk
touch /etc/wpa_supplicant/wpa_supplicant.conf
reboot