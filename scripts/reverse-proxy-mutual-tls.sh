#!/bin/bash

set -e

mv target.crt /etc/ssl/certs/target.crt
mv target.key /etc/ssl/private/target.key
mv prometheus-ca.crt /etc/ssl/certs/prometheus-ca.crt

HOST="localhost"
PORT="9100"

# run script as root or with sudo

# install nginx and openssl
apt -y install nginx openssl

echo 'server {
  listen 443;
  ssl    on;
  ssl_certificate /etc/ssl/certs/target.crt;
  ssl_certificate_key /etc/ssl/private/target.key;
  ssl_client_certificate /etc/ssl/certs/prometheus-ca.crt;
  ssl_verify_client on;
  location / {
    proxy_pass http://'${HOST}':'${PORT}'/;
  }
}' > /etc/nginx/sites-enabled/node-exporter

systemctl enable nginx
systemctl restart nginx

EXTERNAL_IP=$(curl -s ifconfig.co)
echo "Reverse proxy with mutual tls enabled on https://${EXTERNAL_IP}"

