#!/bin/bash

#https://github.com/prometheus/blackbox_exporter/releases/download/v0.18.0/blackbox_exporter-0.18.0.linux-amd64.tar.gz
BLACKBOX_EXPORTER_VERSION="0.18.0"
wget https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_EXPORTER_VERSION}/blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzvf consul_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
cd consul_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64
cp consul_exporter /usr/local/bin

# create user
useradd --no-create-home --shell /bin/false blackbox_exporter

chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter

echo '[Unit]
Description=blackbox_exporter
Wants=network-online.target
After=network-online.target

[Service]
User=blackbox_exporter
Group=blackbox_exporter
Type=service
ExecStart=/usr/local/bin/blackbox_exporter

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/blackbox_exporter.service

# enable blackbox_exporter in systemctl
systemctl daemon-reload
systemctl start blackbox_exporter
systemctl enable blackbox_exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

  
  - job_name: blackbox_metadata
    params:
      module: [http_2xx]
      target:
        - https://wikipedia.com
    metrics_path: /probe
    scrape_interval: 30s
    scrape_timeout: 10s
    static_configs:
      - targets:
        - south.rootsami.dev:9115
        - north.rootsami.dev:9115
        - east.rootsami.dev:9115
    relabel_configs:
      - source_labels: [__param_target]
        target_label: target
      - source_labels: [__address__]
        separator:     ';'
        regex:         '(.*):.*'
        target_label: instance
        replacement:   'ip:9115'
"
