#!/bin/bash
HAPROXY_EXPORTER_VERSION="0.12.0"
#https://github.com/prometheus/haproxy_exporter/releases/download/v0.12.0/haproxy_exporter-0.12.0.linux-amd64.tar.gz
wget https://github.com/prometheus/haproxy_exporter/releases/download/v${HAPROXY_EXPORTER_VERSION}/haproxy_exporter-${HAPROXY_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzvf haproxy_exporter-${HAPROXY_EXPORTER_VERSION}.linux-amd64.tar.gz
cd haproxy_exporter-${HAPROXY_EXPORTER_VERSION}.linux-amd64
cp haproxy_exporter /usr/local/bin

# create user
useradd --no-create-home --shell /bin/false haproxy_exporter

chown haproxy_exporter:haproxy_exporter /usr/local/bin/haproxy_exporter

echo '[Unit]
Description=Haproxy Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=haproxy_exporter
Group=haproxy_exporter
Type=simple
ExecStart=/usr/local/bin/haproxy_exporter \
--haproxy.scrape-uri="http://ip:9595/stats;csv"

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/haproxy_exporter.service

# enable haproxy_exporter in systemctl
systemctl daemon-reload
systemctl start haproxy_exporter
systemctl enable haproxy_exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

  - job_name: 'haproxy_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
"

