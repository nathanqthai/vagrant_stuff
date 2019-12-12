#!/bin/bash -x

VAGRANT_SHARE=$1
TMP_DIR=$2

# create kafka user
useradd kafka -m
passwd kafka -l

# install javascript
apt-get update
apt-get -y install default-jdk

# fetch kafka as kafka user
sudo -u kafka -i << 'EOF'
    mkdir ~/tmp
    curl "http://mirrors.ocf.berkeley.edu/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz" -o ~/tmp/kafka.tgz
    mkdir ~/kafka && cd ~/kafka
    tar -xvzf ~/tmp/kafka.tgz --strip 1
EOF

# enable topic deletion
sudo -u kafka -i << 'EOF'
    echo "delete.topic.enable = true" >>  ~/kafka/config/server.properties
EOF

cp ${VAGRANT_SHARE}/zookeeper.service /etc/systemd/system/zookeeper.service
chmod 664 /etc/systemd/system/kafka.service
cp ${VAGRANT_SHARE}/kafka.service /etc/systemd/system/kafka.service
chmod 664 /etc/systemd/system/kafka.service
systemctl start kafka
journalctl -u kafka
systemctl enable kafka
