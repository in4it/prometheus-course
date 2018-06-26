#!/bin/bash

# unattended postfix install
debconf-set-selections <<< "postfix postfix/mailname string your.domain.com"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install -y postfix
apt-get install -y mailutils

# set config to send-only and from localhost
echo '
smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no
append_dot_mydomain = no
readme_directory = no
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = prometheus.com
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = $myhostname, localhost.$mydomain, $mydomain
relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = loopback-only
inet_protocols = all
' > /etc/postfix/main.cf

# restart postfix
service postfix restart

echo "(1/2)Setup complete.
Add the following lines and substitute with correct values to /etc/alertmanager/alertmanager.yml:
echo "You successfully installed the mail server" | mail -s "Prometheus mail server OK" <your-email-here>
If your mail isn't received check the syslog(tail -f /var/log/syslog) and the spam folder.
"

