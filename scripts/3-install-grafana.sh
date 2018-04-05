#!/bin/bash
echo 'deb https://packagecloud.io/grafana/stable/debian/ jessie main' >> /etc/apt/sources.list
curl https://packagecloud.io/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install grafana

systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service
