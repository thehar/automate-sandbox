#!/usr/bin/env bash

apt-get update -y -qq > /dev/null
apt-get upgrade -y -qq > /dev/null
apt-get -y -q install linux-headers-$(uname -r) build-essential > /dev/null
sysctl -w vm.max_map_count=262144
sysctl -w vm.dirty_expire_centisecs=20000

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
192.168.33.198  chef-server chef-server.test
192.168.33.199  chef-automate chef-automate.test
EOL

curl https://packages.chef.io/files/current/automate/latest/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
sudo ./chef-automate deploy --accept-terms-and-mlsa --fqdn chef-automate.test
echo "[auth_n.v1.sys.service]" >data-collector-token.toml
echo "a1_data_collector_token = \"93a49a4f2482c64126f7b6015e6b0f30284287ee4054ff8807fb63d9cbd1c506\"" >>data-collector-token.toml
sudo ./chef-automate config patch data-collector-token.toml


echo "Chef Console is ready: https://chef-automate.test with login:"
sudo cat automate-credentials.toml
