#!/usr/bin/env bash

apt-get update -y -qq > /dev/null
apt-get upgrade -y -qq > /dev/null
apt-get -y -q install linux-headers-$(uname -r) build-essential > /dev/null

wget -P /tmp https://packages.chef.io/files/stable/chef-server/12.19.26/ubuntu/16.04/chef-server-core_12.19.26-1_amd64.deb > /dev/null
dpkg -i /tmp/chef-server-core_12.19.26-1_amd64.deb

chown -R vagrant:vagrant /home/vagrant

mkdir /home/vagrant/certs

chef-server-ctl reconfigure
printf "\033c"
chef-server-ctl user-create upwork Automate Lab automate@labz.com password --filename /home/vagrant/certs/upwork.pem
chef-server-ctl org-create upwork "Upwork Automate Lab" --association_user upwork --filename /home/vagrant/certs/upworkorg.pem
chef-server-ctl install chef-manage
chef-server-ctl reconfigure
chef-manage-ctl reconfigure --accept-license


cat >> /etc/hosts <<EOF
192.168.33.199  chef-automate.test
192.168.33.198  chef-server.test
EOF
