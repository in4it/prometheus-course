#!/bin/bash
CONSUL_EXPORTER_VERSION="0.3.0"
wget https://github.com/prometheus/consul_exporter/releases/download/v${CONSUL_EXPORTER_VERSION}/consul_exporter-${CONSUL_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzvf consul_exporter-${CONSUL_EXPORTER_VERSION}.linux-amd64.tar.gz
cd consul_exporter-${CONSUL_EXPORTER_VERSION}.linux-amd64
cp consul_exporter /usr/local/bin

# create user
useradd --no-create-home --shell /bin/false consul_exporter

chown consul_exporter:consul_exporter /usr/local/bin/consul_exporter

echo '[Unit]
Description=Consul Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=consul_exporter
Group=consul_exporter
Type=simple
ExecStart=/usr/local/bin/consul_exporter

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/consul_exporter.service

# enable consul_exporter in systemctl
systemctl daemon-reload
systemctl start consul_exporter
systemctl enable consul_exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

  - job_name: 'consul_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9107']
"
