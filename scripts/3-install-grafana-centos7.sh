#!/bin/bash
# Create repo and install Grafana OSS release on Centos 7
cat > /etc/yum.repos.d/grafana.repo <<EOL
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

EOL

sudo yum update
sudo yum install -y grafana

sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
