#!/usr/bin/env bash

apt-get update -y -qq > /dev/null
apt-get upgrade -y -qq > /dev/null
apt-get -y -q install linux-headers-$(uname -r) build-essential > /dev/null

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOF
192.168.33.199  chef-automate.test
192.168.33.198  chef-server.test
EOF

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

chef-server-ctl set-secret data_collector token '93a49a4f2482c64126f7b6015e6b0f30284287ee4054ff8807fb63d9cbd1c506'
chef-server-ctl restart nginx
chef-server-ctl restart opscode-erchef
echo "data_collector['root_url'] = 'https://chef-automate.test/data-collector/v0/'" >> /etc/opscode/chef-server.rb
echo "profiles['root_url'] = 'https://chef-automate.test'" >> /etc/opscode/chef-server.rb
chef-server-ctl reconfigure
