
##############################################################################################
#
# Raspberry PI Wifi Configuration
#
##############################################################################################

# Figure out operating system of Raspberry PI
uname -a


# Download Driver (based on operating system & version)
# https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=62371
# I am currently running 3.18.11-v7+ #776, #777 - 8188eu-v7-20150406.tar.gz
wget https://dl.dropboxusercontent.com/u/80256631/8188eu-v7-20150406.tar.gz
tar -zxvf 8188eu-v7-20150406.tar.gz
./install.sh


# Modify the wpa-supplicant file
# http://mycyberuniverse.com/linux/connect-raspberry-pi-to-the-wifi-network.html
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
# Add the following lines
network={
     ssid="Your SSID Here"
     psk="Enter Passkey Here"
     proto=RSN
     key_mgmt=WPA-PSK
     pairwise=CCMP TKIP
     group=CCMP TKIP
}


# OR...for more than one connection
network={
     ssid="Your SSID Here"
     psk="Enter Passkey Here"
     proto=RSN
     key_mgmt=WPA-PSK
     pairwise=CCMP TKIP
     group=CCMP TKIP
     id_str="home"
     priority=1
}

network={
     ssid="Your SSID Here"
     psk="Enter Passkey Here"
     proto=RSN
     key_mgmt=WPA-PSK
     pairwise=CCMP TKIP
     group=CCMP TKIP
     id_str="work"
     priority=2
}





# After changes have been maid to the wpa_supplicant.conf file...
sudo ifdown wlan0
sudo ifup wlan0
sudo iwconfig


# Reload the networking Services
sudo service networking reload


# Reboot

sudo reboot



# Scan all Wifi Networks
sudo iwlist wlan0 scan
sudo iwconfig wlan0 essid YOUR_SSID key YOUR_PASSWORD
sudo dhclient wlan0


# Some other CMDs to check
ifconfig
lsusb
lsmod
iwlist wlan0 scan


#ZEND

