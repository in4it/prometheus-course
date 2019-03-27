#!/bin/bash
echo 'deb https://packages.grafana.com/oss/deb stable main' >> /etc/apt/sources.list
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install grafana

systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service
