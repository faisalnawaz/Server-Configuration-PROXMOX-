#!/bin/sh


echo "Bond Configuration ...!"

echo "Getting LAN Ports ...!"

ip='192.168.0.107'
gtwy='192.168.0.1'

first_LAN=$(ip a | grep en | cut -d : -f 2 | head -2 | tail -1)
second_LAN=$(ip a | grep en | cut -d : -f 2 | head -3 | tail -1)
third_LAN=$(ip a | grep en | cut -d : -f 2 | head -4 | tail -1)
fourth_LAN=$(ip a | grep en | cut -d : -f 2 | head -5 | tail -1)

echo $first_LAN
echo $second_LAN
echo $third_LAN
echo $fourth_LAN

echo "Copying Actual Network File to root  ...!"
#cp /etc/network/interfaces /root/

echo "Creating Interfaces ...!"

echo " " > /etc/network/interfaces
echo " " >> /etc/network/interfaces
echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo " " >> /etc/network/interfaces

echo "auto $first_LAN" >> /etc/network/interfaces
echo "iface $first_LAN inet manual" >> /etc/network/interfaces
echo " " >> /etc/network/interfaces

echo "auto $second_LAN" >> /etc/network/interfaces
echo "iface $second_LAN inet manual" >> /etc/network/interfaces
echo " " >> /etc/network/interfaces

echo "auto $third_LAN" >> /etc/network/interfaces
echo "iface $third_LAN inet manual" >> /etc/network/interfaces
echo " "

echo "auto $fourth_LAN" >> /etc/network/interfaces
echo "iface $fourth_LAN inet manual" >> /etc/network/interfaces
echo " " >> /etc/network/interfaces


echo "Creating Bonds ...!"

echo "auto bond0" >> /etc/network/interfaces
echo "iface bond0 inet manual" >> /etc/network/interfaces
echo "	bond-slaves $first_LAN $second_LAN" >> /etc/network/interfaces
echo "	bond-miimon 100" >> /etc/network/interfaces
echo "	bond-mode active-backup" >> /etc/network/interfaces
echo "	bond-primary $first_LAN" >> /etc/network/interfaces
echo " " >> /etc/network/interfaces


echo "auto bond1" >> /etc/network/interfaces
echo "iface bond1 inet manual" >> /etc/network/interfaces
echo "	bond-slaves $third_LAN $fourth_LAN" >> /etc/network/interfaces
echo "	bond-miimon 100" >> /etc/network/interfaces
echo "	bond-mode active-backup" >> /etc/network/interfaces
echo "	bond-primary $third_LAN" >> /etc/network/interfaces
echo " " >> /etc/network/interfaces

echo "Creating Vmbrs ...!"

echo "auto vmbr0" >> /etc/network/interfaces
echo "iface vmbr0 inet static" >> /etc/network/interfaces
echo "	address $ip/24" >> /etc/network/interfaces
echo "	gateway $gtwy" >> /etc/network/interfaces
echo "	bridge-ports bond0" >> /etc/network/interfaces
echo "	bridge-stp off" >> /etc/network/interfaces
echo "	bridge-fd 0"
echo " " >> /etc/network/interfaces


echo "auto vmbr1" >> /etc/network/interfaces
echo "iface vmbr1 inet manual" >> /etc/network/interfaces
echo "	bridge-ports bond1" >> /etc/network/interfaces
echo "	bridge-stp off" >> /etc/network/interfaces
echo "	bridge-fd 0"
echo " " >> /etc/network/interfaces

systemctl restart networking


