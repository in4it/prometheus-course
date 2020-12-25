#!/bin/bash
SNMP_EXPORTER_VERSION="0.19.0"
wget https://github.com/prometheus/snmp_exporter/releases/download/v${SNMP_EXPORTER_VERSION}/snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzvf snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-amd64.tar.gz
cd snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-amd64
cp snmp_exporter /usr/local/bin

#https://github.com/prometheus/snmp_exporter/releases/download/v0.19.0/snmp_exporter-0.19.0.linux-amd64.tar.gz

# create user
useradd --no-create-home --shell /bin/false snmp_exporter

chown snmp_exporter:snmp_exporter /usr/local/bin/snmp_exporter

echo '[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=snmp_exporter
Group=snmp_exporter
Type=simple
ExecStart=/usr/local/bin/snmp_exporter

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/snmp_exporter.service

# enable snmp_exporter in systemctl
systemctl daemon-reload
systemctl start snmp_exporter
systemctl enable snmp_exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

# A scrape configuration containing exactly one endpoint to scrape:
scrape_configs:
  # Cisco
  - job_name: 'Cisco'
    scrape_interval: 120s
    scrape_timeout: 120s
    file_sd_configs:
        - files :
          - /etc/prometheus/targetCisco.yml
    # SNMP device.
    metrics_path: /snmp
    params:
      module: [Cisco] #which OID's we will be querying in
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - target_label: __address__
        replacement: 127.0.0.1:9116  # The SNMP exporter's real hostname:port.

"

