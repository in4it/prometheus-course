# Running Prometheus on Kubernetes

# Install Helm
```
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
tar -xzvf helm-v2.11.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
kubectl create -f https://raw.githubusercontent.com/wardviaene/kubernetes-course/master/helm/helm-rbac.yaml
helm init --service-account tiller 
```
## Start Prometheus (without storage)
```
helm install --name prometheus --set server.persistentVolume.enabled=false,alertmanager.persistentVolume.enabled=false stable/prometheus
```

## Exposing prometheus port
```
export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 9090 &
socat TCP4-LISTEN:9091,fork TCP4:localhost:9090 &
```
