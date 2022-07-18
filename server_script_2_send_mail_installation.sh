#!/bin/sh


##Send mail Configuration List

echo "Installing Sendmail...!"

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



