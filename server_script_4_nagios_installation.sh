#!/bin/sh


echo "Installing Nrpe ...!"


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



