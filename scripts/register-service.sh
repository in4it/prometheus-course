#!/bin/bash
IP=$(curl -s ifconfig.co)
curl -X PUT -d '{
  "ID": "python-flask",
  "Name": "python-flask",
  "Address": "'${IP}'",
  "Port": 8000,
  "Check": {
    "Name": "HTTP check",
    "Interval": "30s",
    "HTTP": "http://'${IP}':5000/"
  }
}' http://localhost:8500/v1/agent/service/register

