#PROXY
ssh root@vmi2397473.contaboserver.net
ansible-playbook -i inventory_root.ini init_setup.yml -k --limit vmi2397473.contaboserver.net
./copy-private-key.sh vmi2397473.contaboserver.net
ssh -i keys/vmi2397473.contaboserver.net -p 22000 operador@vmi2397473.contaboserver.net
#ALTTERNATIVO

ssh root@vmi2381341.contaboserver.net
ssh root@vmi2379375.contaboserver.net


sudo ufw allow 80
sudo ufw allow 443

apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
apt update
apt install caddy

sudo ufw allow from 10.0.0.0/24
sudo ufw allow out to 10.0.0.0/24


sudo ufw route allow from 167.86.75.122 to 172.20.0.2 port 27017 comment "Kubernetes Worker01 para MNGLOGIN-PROD"
sudo ufw route allow from 167.86.75.122 to 172.20.0.8 port 8083 comment "Kubernetes Worker01 para MQTT" #WORWER01
sudo ufw route allow from 213.136.79.113 to 172.20.0.8 port 8083 comment "Kubernetes proxy para MQTT" #PROXY

sudo ufw route allow from 167.86.75.122 to 172.19.0.8 port 8083 comment "Kubernetes Worker01 para MQTT-PREPROD"
sudo ufw route allow from 213.136.79.113 to 172.19.0.8 port 8083 comment "Kubernetes proxy para MQTT-PREPROD"

sudo ufw route allow from 190.218.156.57 to 172.17.0.2 port 9000 comment "acceso portainer para Carlos Panama" #PROXY

sudo ufw route allow from 190.218.156.57 to 172.17.0.2 port 9000 comment "acceso portainer para Carlos Panama"
sudo ufw route allow from 88.177.45.169 to 172.17.0.2 port 9000 comment "acceso portainer para mi"
sudo ufw route allow from 181.55.20.12 to 172.17.0.2 port 9000 comment "acceso portainer para Andres"
sudo ufw route allow from 191.110.102.237 to 172.17.0.2 port 9000 comment "acceso a conexion a portainer para Javier"
sudo ufw route allow from 185.146.222.88 to 172.17.0.2 port 9000 comment "tempo david"
sudo ufw route allow from 45.173.12.105 to 172.17.0.2 port 9000 comment "acceso a conexion a portainer para Omar"
sudo ufw route allow from 186.84.89.211 to 172.17.0.2 port 9000 comment "acceso portainer para Brayan"
sudo ufw route allow from 191.110.243.254 to 172.17.0.2 port 9000 comment "acceso portainer para Javier"

172.17.0.2 9000            ALLOW FWD                 # 
172.17.0.2 9000            ALLOW FWD                  # 
172.17.0.2 9000/tcp        ALLOW FWD               # 
172.17.0.2 9000            ALLOW FWD                # tempo david
172.17.0.2 9000/tcp        ALLOW FWD                  # acceso portainer para Carlos
172.17.0.2 9000/tcp        ALLOW FWD                 # 
172.17.0.2 9000            ALLOW FWD                 # 
172.17.0.2 9000            ALLOW FWD   190.218.156.57             # acceso portainer para Carlos Panama


docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5
docker run -d --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5


10.0.0.2 vmi2104422.contaboserver.net
10.0.0.9 vmi2379375.contaboserver.net
10.0.0.8 vmi2381341.contaboserver.net
10.0.0.6 vmi2394791.contaboserver.net
10.0.0.3 vmi2104421.contaboserver.net