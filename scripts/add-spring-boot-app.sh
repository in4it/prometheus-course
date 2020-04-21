#!/bin/bash
echo "  - job_name: 'spring_boot_demo_app'
    scrape_interval: 5s
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['localhost:8080']" >> /etc/prometheus/prometheus.yml

