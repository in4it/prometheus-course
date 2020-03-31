#!/bin/bash
firewall-cmd --zone=public --permanent --add-port=3000/tcp  # Grafana
firewall-cmd --zone=public --permanent --add-port=9090/tcp  # Prometheus
firewall-cmd --zone=public --permanent --add-port=9100/tcp  # Node Exporter
firewall-cmd --reload
firewall-cmd --list-all --zone=public
