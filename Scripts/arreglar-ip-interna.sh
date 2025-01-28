vi /etc/netplan/02-netcfg.yaml
ip addr show eth1 #Inentificar direccion MAC de la tarjeta
ip link set eth1 up #Levantar la interfaz manualmente
apt install openvswitch-switch
chmod 600 /etc/netplan/02-netcfg.yaml
chown root:root /etc/netplan/02-netcfg.yaml
netplan apply #Aplicar cambios de la red

#86:40:7d:e9:f5:04 vmi2104422 worker001 10.0.0.2/22
#76:17:d7:42:ea:1d vmi2394791 master002 10.0.0.6/22

sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0

network:
  version: 2
  ethernets:
    eth1:
      match:
        macaddress: "bc:24:11:00:e4:bd"
      addresses:
      - "10.0.0.2/22"
      nameservers:
        addresses:
        - 195.179.224.51
        - 195.179.224.52
        - 2a02:c202:5028::1:53
      set-name: "eth1"