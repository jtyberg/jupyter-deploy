# Jupyter Notebook on Kubernetes


## Minikube (Local)

Install [minikube](https://github.com/kubernetes/minikube/releases).

Start.

```
minikube start
```

Build notebook image using Docker daemon on minikube VM.

```
eval $(minikube docker-env)

docker build -t jtyberg/notebook ..
```

Deploy notebook as service.

```
kubectl create -f deployment.yml
```

Open browser pointed at notebook server.

```
export NODE_IP=$(minikube ip) && \
export NODE_PORT=$(kubectl get svc notebook -o jsonpath='{.spec.ports[*].nodePort}') && \
open http://$NODE_IP:$NODE_PORT
```
