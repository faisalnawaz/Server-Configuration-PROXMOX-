#!/bin/sh


echo "Basic Configuration...!"

sed -i '/deb/c\#deb https://enterprise.proxmox.com/debian/pve buster pve-enterprise' /etc/apt/sources.list.d/pve-enterprise.list
echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list.d/pve-no-subscription.list

apt update -y
apt upgrade -y

echo "Installing Packages...!"

apt install screen -y
apt-get install ntp -y
apt-get install ntpdate -y
apt install sudo
apt-get install htop
apt-get install vim -y
apt install acl
apt install iftop
apt install parted -y
apt-get install kpartx -y
apt install nfs* -y
apt-get install net-tools -y
apt-get install net-tools* -y
apt install mlocate


echo "Installing ifupdown2...!"
apt update
apt install ifupdown2 -y

echo "Editing GRUB FIlE...!"
sed -i '/GRUB_CMDLINE_LINUX/c\GRUB_CMDLINE_LINUX="rootdelay=10"' /etc/default/grub

echo "Editing lxcfs...!"
sed -i '/ExecStart=/c\ExecStart=/usr/bin/lxcfs -l /var/lib/lxcfs' /lib/systemd/system/lxcfs.service
systemctl restart lxcfs


echo "Enabling NFS ...!"

sed -i '/mount fstype=cgroup2/a\       mount fstype=nfs*,' /etc/apparmor.d/lxc/lxc-default-cgns
sed -i '/mount fstype=nfs/a\       mount fstype=rpc_pipefs,' /etc/apparmor.d/lxc/lxc-default-cgns

/etc/init.d/apparmor reload

systemctl daemon-reload

echo "Disabling Firewall...!"
systemctl stop pve-firewall
systemctl disable pve-firewall


echo "Basic Configuration completed...!"

