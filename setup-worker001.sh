#!/bin/bash

#MASTER001
ssh root@vmi2104422.contaboserver.net
ansible-playbook -i inventory_root.ini init_setup.yml -k --limit vmi2104422.contaboserver.net
./copy-private-key.sh vmi2104422.contaboserver.net
ssh -i keys/vmi2104422.contaboserver.net -p 22000 operador@vmi2104422.contaboserver.net

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging low
sudo reboot

ansible-playbook -i inventory_oper.ini kubernetes-worker/1-install_rke2.yml --limit vmi2104422.contaboserver.net
ansible-playbook -i inventory_oper.ini kubernetes-worker/put_token.yml  --limit vmi2104422.contaboserver.net