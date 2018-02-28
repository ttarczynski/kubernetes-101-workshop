#!/bin/bash

set -x

yum install -y nfs-utils

mkdir -p /var/export
chmod -R 755 /var/export
chown nfsnobody:nfsnobody /var/export

cat <<EOF > /etc/exports
/var/export    *(rw,sync,no_root_squash,no_all_squash)
EOF

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap
