#!/bin/bash

yum install -y nfs-utils

mkdir -p /home/nfs/user01/share1
mkdir -p /home/nfs/user02/share1
mkdir -p /home/nfs/user03/share1
mkdir -p /home/nfs/user04/share1
mkdir -p /home/nfs/user05/share1
mkdir -p /home/nfs/user06/share1

mkdir -p /home/nfs/user02/share2
mkdir -p /home/nfs/user02/share3
mkdir -p /home/nfs/user02/share4
mkdir -p /home/nfs/user02/share5

mkdir -p /home/nfs/user03/share2
mkdir -p /home/nfs/user03/share3
mkdir -p /home/nfs/user03/share4
mkdir -p /home/nfs/user03/share5

mkdir -p /home/nfs/user04/share2
mkdir -p /home/nfs/user04/share3
mkdir -p /home/nfs/user04/share4
mkdir -p /home/nfs/user04/share5

mkdir -p /home/nfs/user05/share2
mkdir -p /home/nfs/user05/share3
mkdir -p /home/nfs/user05/share4
mkdir -p /home/nfs/user05/share5

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap
systemctl restart nfs-server
firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload

# /etc/exports
# /var/nfs_share_dir    192.168.48.101(rw,sync,no_root_squash)

yum install -y qemu-kvm qemu-img bridge-utils libvirt libvirt-client virt-install  libguestfs-tools

echo -e "[main]\ndns=dnsmasq" > /etc/NetworkManager/conf.d/nm-dns.conf
systemctl restart NetworkManager

firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --add-port=6443/tcp

for vm in $(virsh list --all --name --no-autostart | grep "ocp"); do
  virsh autostart ${vm}
done
