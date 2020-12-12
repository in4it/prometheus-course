#!/bin/bash
echo "  - job_name: 'flask_app'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:8000']" >> /etc/prometheus/prometheus.yml

