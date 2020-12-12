#!/bin/bash
docker run --name consul -d --net=host -v /consul/data:/consul/data \
-e CONSUL_LOCAL_CONFIG='{
"datacenter":"eu-west",
"server":true,
"enable_debug":true
}' consul:1.2.1 agent -server -bind 127.0.0.1 -bootstrap-expect=1 

echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

  - job_name: 'consul'
    consul_sd_configs:
      - server:   '127.0.0.1:8500'

    relabel_configs:
    - source_labels: ['__meta_consul_service']
      regex:         '(.*)'
      target_label:  'job'
      replacement:   '\$1'
    - source_labels: ['__meta_consul_node']
      regex:         '(.*)'
      target_label:  'instance'
      replacement:   '\$1'
    - source_labels: ['__meta_consul_tags']
      regex:         ',(dev|production|canary),'
      target_label:  'group'
      replacement:   '\$1'
"
