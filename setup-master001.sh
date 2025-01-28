#!/bin/bash

ansible-playbook -i inventory_oper.ini external_ufw.yaml
ssh operador@vmi2394791.contaboserver.net vmi2160927.contaboserver.net

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

chmod 600 /root/.kube/config
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.16.2 --set crds.enabled=true
kubectl create namespace cattle-system
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
helm upgrade --install rancher rancher-latest/rancher --namespace cattle-system --set hostname=vmi2394791.contaboserver.net --set bootstrapPassword=adminPassword2025 --set ingress.enabled=false --set replicas=3
kubectl rollout status deployment -n cattle-system rancher

ansible-playbook -i inventory_oper.ini kubernetes/get_token.yml  --limit vmi2394791.contaboserver.net
ansible-playbook -i inventory_oper.ini kubernetes/put_token.yml  --limit vmi2394791.contaboserver.net

sudo ufw allow 30443
ufw route allow from any to 10.43.144.187 port 30443

sudo rke2 server --node-ip=10.0.0.6 --tls-san=10.0.0.6 # <--- Este si funciono

sudo rke2 server \
  --node-ip=<private_ip> \
  --node-external-ip=<public_ip> \
  --tls-san=<private_ip> \
  --tls-san=<public_ip> \

sudo systemctl stop rke2-server
sudo systemctl stop rke2-agent
sudo systemctl disable rke2-server
sudo systemctl disable rke2-agent
sudo rm -rf /etc/rancher/rke2
sudo rm -rf /var/lib/rancher/rke2
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/cni
sudo rm -rf /etc/cni
sudo rm -rf /run/k3s
sudo rm -f /usr/local/bin/rke2*
sudo rm -f /usr/bin/kubectl
sudo rm -rf /var/log/rke2*
ps aux | grep rke2
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X

https://github.com/atmosferia-projects/portainer-config.git

#portainer-config/kubernetes/configmap/main-application-layer/desarrollo
kubectl create configmap dev-main-application-layer-configmap --from-env-file=configmap --namespace=dev-main-applications

#portainer-config/kubernetes/secrets/main-application-layer/desarrollo
kubectl create secret generic dev-main-application-layer-secrets --from-env-file=secrets --namespace=dev-main-applications

kubectl apply -f api-detections-devel-deployment.yaml
kubectl apply -f api-detections-devel-service.yaml

kubectl create secret docker-registry actiontracker-dockerhub \
  --docker-username="david.ballester@actiontracker.es" \
  --docker-password="ActionTracker_docker_2020!" \
  --docker-server="https://index.docker.io/v1/" \
  --namespace=dev-main-applications

sudo ufw allow from 10.0.0.0/24
sudo ufw allow out to 10.0.0.0/24

mount -t cifs -o gid=101010,username=smbuser,password=884gA3lHA9KKtRh //10.0.0.2/K8S-Share/dev/geoserver/data-storage /mnt/test



#SETUP MASTER002
ssh root@vmi2379375.contaboserver.net
ansible-playbook -i inventory_root.ini init_setup.yml -k --limit vmi2379375.contaboserver.net
./copy-private-key.sh vmi2379375.contaboserver.net
ssh -i keys/vmi2379375.contaboserver.net -p 22000 operador@vmi2379375.contaboserver.net

sudo ufw allow from 10.0.0.0/24
sudo ufw allow out to 10.0.0.0/24

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging low
sudo reboot

sudo apt update && sudo apt upgrade -y
curl -sfL https://get.rke2.io | sh -
sudo rke2 server --node-ip=10.0.0.9 --tls-san=10.0.0.9 --token K102f1c5d95552b124d44220c4ea444e901c0576964537142afe2461037488e0799::server:516b46dc6237c77fde75e15c5dd462bf --server=https://10.0.0.6:9345

vi /etc/rancher/rke2/config.yaml

sudo systemctl enable rke2-server
sudo systemctl start rke2-server

mkdir -p /root/.kube
sudo cp /etc/rancher/rke2/rke2.yaml /root/.kube/config
sudo chown root:root /root/.kube/config
sudo install -o root -g root -m 0755 /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
kubectl get nodes

sudo apt install etcd-client -y
etcdctl --endpoints=https://127.0.0.1:2379 member list

export ETCDCTL_API=3
etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
    --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
    --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
    endpoint health

etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
    --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
    --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
    member list

#VERIFICAR EL LIDERAZGO
etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
    --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
    --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
    endpoint status --write-out=table



#SETUP MASTER003
ssh root@vmi2381341.contaboserver.net
ansible-playbook -i inventory_root.ini init_setup.yml -k --limit vmi2381341.contaboserver.net
./copy-private-key.sh vmi2381341.contaboserver.net
ssh -i keys/vmi2381341.contaboserver.net -p 22000 operador@vmi2381341.contaboserver.net

sudo ufw allow from 10.0.0.0/24
sudo ufw allow out to 10.0.0.0/24

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging low
sudo reboot

#VERIFICAR IP INTERNA Y CONEXION

sudo apt update && sudo apt upgrade -y
curl -sfL https://get.rke2.io | sh -
sudo rke2 server --node-ip=10.0.0.8 --tls-san=10.0.0.8,10.0.0.6,10.0.0.9 --token K102f1c5d95552b124d44220c4ea444e901c0576964537142afe2461037488e0799::server:516b46dc6237c77fde75e15c5dd462bf --server=https://10.0.0.6:9345

vi /etc/rancher/rke2/config.yaml

sudo systemctl enable rke2-server
sudo systemctl start rke2-server

mkdir -p /root/.kube
sudo cp /etc/rancher/rke2/rke2.yaml /root/.kube/config
sudo chown root:root /root/.kube/config
sudo install -o root -g root -m 0755 /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
kubectl get nodes

sudo apt install etcd-client -y
etcdctl --endpoints=https://127.0.0.1:2379 member list

export ETCDCTL_API=3
etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
    --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
    --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
    endpoint health

etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
    --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
    --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
    member list

#VERIFICAR EL LIDERAZGO
etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
    --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
    --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
    endpoint status --write-out=table

207.180.231.70
207.180.195.61
207.180.209.19
167.86.75.122
167.86.75.155
telnet 10.0.0.6 30443
telnet 10.0.0.8 30443
telnet 10.0.0.9 30443