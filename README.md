# Rucky-Ext-RPi
Raspberry Pi Extension for Rucky

## Devices
- Raspberry Pi 0W/0WH

## AP Details
- SSID: RUCKY (do not change)

## Setup
- Install [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/).
- Run `sudo apt update -y && sudo apt upgrade -y`.
- Setup [Wireless AP](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md).
- Replace `/etc/hostapd/hostapd.conf` with [Rucky hostapd file](https://raw.githubusercontent.com/mayankmetha/Rucky-Ext-RPi/master/hostapd.conf).
- Add a password to hostapd.conf after `wpa_passphrase=`.
- Reboot Raspberry Pi and connect to Raspberry Pi's RUCKY AP to configure futher.
- If ethernet ssh is enabled in cmdline.txt and config.txt, disable it.
- Execute [USB HID Driver Setup](https://raw.githubusercontent.com/mayankmetha/Rucky-Ext-RPi/master/setupRucky.sh) using `sudo bash setupRucky.sh`.
- TODO: Still under development
