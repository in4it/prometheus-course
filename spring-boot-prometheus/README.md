# Spring Boot demo app

This is a demo application used in the Prometheus Udemy training, This demonstrates the use of spring boot 2 with micrometer and prometheus to generate app metrics and custom metrics.

## Demo

### Build
`docker build -t spring-demo-app .`

### Run
`docker run --rm -p 8080:8080 --name spring-demo-app spring-demo-app`

### Oneliner
Build and Run the container via `docker build -t spring-demo-app . && docker run --rm -p 8080:8080 --name spring-demo-app spring-demo-app`

## Access
### App
`http://localhost:8080/api/demo`
`http://localhost:8080/api/delayed/demo`

### Prometheus metrics
`http://localhost:8080/actuator/prometheus`


## Queries

### Requests/s globally
`rate(http_server_requests_seconds_count[5m])`

### Requests/s for the demo app
`rate(http_server_requests_seconds_count{uri="/api/demo",status="200"}[5m])`

### Custom metric
`runCounter_total{application="prometheus-demo",job="spring_boot_demo_app"}`

### Requests duration for the delayed demo app
`rate(http_server_requests_seconds_sum{uri="/api/delayed/demo",status="200"}[2m])`
