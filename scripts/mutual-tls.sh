#!/bin/bash

set -ex

TARGET_IP="138.68.135.9"

echo '
# From http://apetec.com/support/GenerateSAN-CSR.htm

[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = Country Name (2 letter code)
countryName_default = US
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = MN
localityName = Locality Name (eg, city)
localityName_default = Minneapolis
organizationalUnitName	= Organizational Unit Name (eg, section)
organizationalUnitName_default	= Domain Control Validated
commonName = Internet Widgits Ltd
commonName_max	= 64

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
extendedKeyUsage = clientAuth,serverAuth
subjectAltName = @alt_names

[alt_names]' > openssl-${TARGET_IP}.cnf

echo -en "IP.1 = ${TARGET_IP}\n" >> openssl-${TARGET_IP}.cnf


# create CA
openssl genrsa -out ca.key 4096 -nodes
chmod 400 ca.key
openssl req -new -x509 -sha256 -days 3650 -key ca.key -out ca.crt -subj "/CN=prometheus-ca.example.com"
chmod 644 ca.crt

# Create target key
openssl genrsa -out target.key 2048
chmod 400 target.key
openssl req -new -key target.key -sha256 -out target.csr -config openssl-${TARGET_IP}.cnf -subj "/CN=prometheus-target.example.com"

openssl x509 -req -days 365 -sha256 -in target.csr -CA ca.crt -CAkey ca.key -set_serial 1 -out target.crt -extensions v3_req -extfile openssl-${TARGET_IP}.cnf
chmod 444 target.crt

# Create client key for prometheus server
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -subj "/CN=prometheus.example.com"
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 2 -out client.crt

mv ca.crt /etc/ssl/certs/prometheus-ca.crt
mv ca.key /etc/ssl/private/prometheus-ca.key
mv client.key /etc/prometheus/prometheus.key
chown prometheus:prometheus /etc/prometheus/prometheus.key
mv client.crt /etc/ssl/certs/prometheus.crt

echo 'Add the following lines to /etc/prometheus/prometheus.yml:'
echo "  - job_name: 'node_exporter_ssl'
    scrape_interval: 5s
    scheme: https
    tls_config:
      ca_file: /etc/ssl/certs/prometheus-ca.crt
      cert_file: /etc/ssl/certs/prometheus.crt
      key_file: /etc/prometheus/prometheus.key
    static_configs:
      - targets: ['${TARGET_IP}:443']"

