#!/bin/bash
CLOUDWATCH_EXPORTER_VERSION="0.4"
wget -O /usr/local/bin/cloudwatch_exporter.jar http://search.maven.org/remotecontent?filepath=io/prometheus/cloudwatch/cloudwatch_exporter/${CLOUDWATCH_EXPORTER_VERSION}/cloudwatch_exporter-${CLOUDWATCH_EXPORTER_VERSION}-jar-with-dependencies.jar

#install java
apt-get install -y openjdk-9-jre-headless

#create configuration directory
mkdir -p /etc/cloudwatchexporter
touch /etc/cloudwatchexporter/cloudwatchexporter.yml
mkdir -p ~/.aws/
touch ~/.aws/credentials

#aws credentail template
echo '[default]
aws_access_key_id=YOUR_ACCESS_KEY_ID
aws_secret_access_key=YOUR_SECRET_ACCESS_KEY' >> ~/.aws/credentials

echo '[Unit]
Description=CLoudwatch Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/bin/java -jar /usr/local/bin/cloudwatch_exporter.jar 9106 /etc/cloudwatchexporter/cloudwatchexporter.yml

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/cloudwatch_exporter.service

# enable node_exporter in systemctl
systemctl daemon-reload
systemctl enable cloudwatch_exporter


echo "Installation complete.

- Add your AWS keys to ~/.aws/credentials (IAM permissions needed: cloudwatch:ListMetrics and cloudwatch:GetMetricStatistics needed)

- Add the following lines to /etc/prometheus/prometheus.yml:

  - job_name: 'cloudwatch_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9106']

- Add the following lines to /etc/cloudwatchexporter/cloudwatchexporter.yml:

---
region: eu-west-1
metrics:
- aws_namespace: AWS/ELB
  aws_metric_name: HealthyHostCount
  aws_dimensions: [AvailabilityZone, LoadBalancerName]
  aws_statistics: [Average]

- run: systemctl start cloudwatch_exporter
"
