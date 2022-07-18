#!/bin/sh

echo ""
echo ""
echo "##########################################################################################################################################################################"
echo "######################################################################  Basic Configuration...!  #########################################################################"
echo "##########################################################################################################################################################################"
echo ""
echo ""


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




##Send mail Configuration List
echo ""
echo ""
echo "##########################################################################################################################################################################"
echo "#######################################################################  Installing Sendmail...!  ########################################################################"
echo "##########################################################################################################################################################################"
echo ""
echo ""


apt-get install sendmail mailutils -y
apt update
apt install postfix -y
apt install postfix -y
apt-get install libsasl2-modules

echo "smtp.gmail.com planetbeyondbackup@gmail.com:pb_support" >> /etc/postfix/sasl_passwd
sed -i '/relayhost/c\relayhost = smtp.gmail.com:587' /etc/postfix/main.cf

postmap hash:/etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd

echo "smtp_use_tls = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
echo "smtp_tls_CAfile = /etc/ssl/certs/Entrust_Root_Certification_Authority.pem" >> /etc/postfix/main.cf
echo "smtp_tls_session_cache_database = btree:/var/lib/postfix/smtp_tls_session_cache" >> /etc/postfix/main.cf
echo "smtp_tls_session_cache_timeout = 3600s" >> /etc/postfix/main.cf

systemctl restart postfix

echo "test message" | mail -s "proxmox6.4 test" faisal.nawaz@planetbeyond.co.uk

echo "Sendmail Succesfully Installed...!"





echo ""
echo ""
echo "##########################################################################################################################################################################"
echo "#####################################################################  Openmanage Installation...!  ######################################################################"
echo "##########################################################################################################################################################################"
echo ""
echo ""


gpg --keyserver keyserver.ubuntu.com --recv-key 1285491434D8786F
gpg -a --export 1285491434D8786F | apt-key add -
echo "deb http://linux.dell.com/repo/community/openmanage/930/bionic bionic main" > /etc/apt/sources.list.d/linux.dell.com.sources.list
wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/libwsman-curl-client-transport1_2.6.5-0ubuntu3_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/libwsman-client4_2.6.5-0ubuntu3_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/libwsman1_2.6.5-0ubuntu3_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/libwsman-server1_2.6.5-0ubuntu3_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/s/sblim-sfcc/libcimcclient0_2.2.8-0ubuntu2_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/openwsman_2.6.5-0ubuntu3_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/multiverse/c/cim-schema/cim-schema_2.48.0-0ubuntu1_all.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/s/sblim-sfc-common/libsfcutil0_1.0.1-0ubuntu4_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/multiverse/s/sblim-sfcb/sfcb_1.4.9-0ubuntu5_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/s/sblim-cmpi-devel/libcmpicppimpl0_2.0.3-0ubuntu2_amd64.deb
dpkg -i libwsman-curl-client-transport1_2.6.5-0ubuntu3_amd64.deb
dpkg -i libwsman-client4_2.6.5-0ubuntu3_amd64.deb
dpkg -i libwsman1_2.6.5-0ubuntu3_amd64.deb
dpkg -i libwsman-server1_2.6.5-0ubuntu3_amd64.deb
dpkg -i libcimcclient0_2.2.8-0ubuntu2_amd64.deb
dpkg -i openwsman_2.6.5-0ubuntu3_amd64.deb
dpkg -i cim-schema_2.48.0-0ubuntu1_all.deb
dpkg -i libsfcutil0_1.0.1-0ubuntu4_amd64.deb
dpkg -i sfcb_1.4.9-0ubuntu5_amd64.deb
dpkg -i libcmpicppimpl0_2.0.3-0ubuntu2_amd64.deb
apt update
apt install srvadmin-all libncurses5 -y
touch /opt/dell/srvadmin/lib64/openmanage/IGNORE_GENERATION
(cd /opt/dell/srvadmin/sbin ; ./srvadmin-services.sh restart)
(cd /opt/dell/srvadmin/sbin ; ./srvadmin-services.sh status)

echo "Openmanage Installed...!"



echo ""
echo ""
echo "##########################################################################################################################################################################"
echo "#######################################################################  Installing Nrpe ...!  ###########################################################################"
echo "##########################################################################################################################################################################"
echo ""
echo ""


echo "Installing Required Packages ...!"
apt-get update
apt-get install -y autoconf automake gcc libc6 libmcrypt-dev make libssl-dev wget


echo "Downloading & Configuring Nrpe from Source ...!"
(cd /tmp ; wget --no-check-certificate -O nrpe.tar.gz https://github.com/NagiosEnterprises/nrpe/archive/nrpe-4.0.3.tar.gz ; tar xzf nrpe.tar.gz)
(cd /tmp/nrpe-nrpe-4.0.3/ ; ./configure --enable-command-args ; make all ; make install-groups-users ; make install ; make install-config)


echo "Creating Service...!"

echo >> /etc/services
echo '# Nagios services' >> /etc/services
echo 'nrpe    5666/tcp' >> /etc/services

echo "Installing Daemon/Service...!"
(cd /tmp/nrpe-nrpe-4.0.3/ ; make install-init)

echo "Enabling & Starting Service...!"
systemctl enable nrpe.service
systemctl start nrpe.service

echo "Testing NRPE...!"
/usr/local/nagios/libexec/check_nrpe -H 127.0.0.1


echo "Installing Plugins...!"

echo "Installing Required Packages ...!"
apt-get install -y autoconf automake gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

echo "Downloading & Configuring Plugins from Source ...!"

(cd /tmp ; wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz ; tar zxf nagios-plugins.tar.gz)
(cd /tmp/nagios-plugins-release-2.2.1/ ; ./tools/setup ; ./configure ; make ; make install)

echo "Testing NRPE Plugins...!"
/usr/local/nagios/libexec/check_nrpe -H 127.0.0.1 -c check_load

systemctl status nrpe


