#!/bin/bash
sudo docker build -t 10.0.0.12:30476/drkiq  .
#minikube start
kubectl apply -f yml/svc/registry-svc.yml
kubectl apply -f yml/deployments/registry-deployment.yml
sleep 5
sudo docker push 192.168.99.100:30476/drkiq
kubectl apply -f yml/pv/all_pv.yml
kubectl apply -f yml/pvc/all_pvc.yml
kubectl apply -f yml/configmap/variables-configmap.yml
kubectl apply -f yml/svc/postgres-svc.yml
kubectl apply -f yml/svc/redis-svc.yml
sleep 5
kubectl apply -f yml/pod/sidekiq-pod.yml
kubectl apply -f yml/deployments/postgres-deployment.yml
kubectl apply -f yml/deployments/redis-deployment.yml
kubectl apply -f yml/svc/drkiq-svc.yml
kubectl apply -f yml/deployments/drkiq-deployment.yml
sleep 5;
curl  http://192.168.99.100:31865/ | grep 'is 42'
if  [ $? -eq 0 ]; then
  echo "Application succesfully deployed";
else
  echo "Error!, please check pods logs .."
  exit -1
fi

