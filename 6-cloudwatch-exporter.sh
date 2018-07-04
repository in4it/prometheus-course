#!/bin/bash
CLOUDWATCH_EXPORTER_VERSION="0.4"
wget -O /usr/local/bin/cloudwatch_exporter.jar http://search.maven.org/remotecontent?filepath=io/prometheus/cloudwatch/cloudwatch_exporter/${CLOUDWATCH_EXPORTER_VERSION}/cloudwatch_exporter-${CLOUDWATCH_EXPORTER_VERSION}-jar-with-dependencies.jar

#install java
apt-get install -y openjdk-9-jre-headless

#create configuration directory
mkdir /etc/cloudwatchexporter
touch /etc/cloudwatchexporter/cloudwatchexporter.yml

echo '[Unit]
Description=CLoudwatch Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=java -jar /usr/local/bin/cloudwatch_exporter.jar 9106 /etc/cloudwatchexporter/cloudwatchexporter.yml

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/cloudwatch_exporter.service

# enable node_exporter in systemctl
systemctl daemon-reload
systemctl start cloudwatch_exporter
systemctl enable cloudwatch_exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

  - job_name: 'cloudwatch_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9106']

AND

Add the following lines to /etc/cloudwatchexporter/cloudwatchexporter.yml:

---
region: eu-west-1
metrics:
- aws_namespace: AWS/ELB
  aws_metric_name: HealthyHostCount
  aws_dimensions: [AvailabilityZone, LoadBalancerName]
  aws_statistics: [Average]

If you want to add config you can reload the cloudwatch_exporter by issuing the following command:
curl -X POST localhost:9106/-/reload
"
