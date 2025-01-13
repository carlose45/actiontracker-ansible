#!/bin/bash

#MASTER001
ssh root@vmi2394791.contaboserver.net
ansible-playbook -i inventory_root.ini init_setup.yml -k --limit vmi2394791.contaboserver.net
./copy-private-key.sh vmi2394791.contaboserver.net
ssh -i keys/vmi2394791.contaboserver.net -p 22000 operador@vmi2394791.contaboserver.net

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging low
sudo reboot

ansible-playbook -i inventory_oper.ini kubernetes/1-install_rke2.yml --limit vmi2394791.contaboserver.net

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.16.2 --set crds.enabled=true
kubectl create namespace cattle-system
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
helm upgrade --install rancher rancher-latest/rancher --namespace cattle-system --set hostname=vmi2394791.contaboserver.net --set bootstrapPassword=adminPassword2025 --set ingress.enabled=false --set replicas=3

ansible-playbook -i inventory_oper.ini kubernetes/get_token.yml  --limit vmi2394791.contaboserver.net
ansible-playbook -i inventory_oper.ini kubernetes/put_token.yml  --limit vmi2394791.contaboserver.net

sudo ufw allow 30443
ufw route allow from any to 10.43.144.187 port 30443