Vagrant.configure(2) do |config|

  config.vm.define :chef_server do |chef_server_config|
      chef_server_config.vm.box = 'bento/ubuntu-16.04'
      chef_server_config.vm.hostname = 'chef-server.test'
      chef_server_config.vm.network :private_network, ip: '192.168.33.198'
      chef_server_config.vm.network 'forwarded_port', guest: 80, host: 8080
      chef_server_config.vm.provider 'virtualbox' do |vb|
        vb.memory = '2048'
      end
      chef_server_config.vm.provision :shell, path: "scripts/install-chef.sh"
  end

  config.vm.define :automate do |automate_config|
    automate_config.vm.box = "bento/ubuntu-16.04"
    automate_config.vm.synced_folder ".", "/opt/a2-testing", create: true
    automate_config.vm.hostname = 'chef-automate.test'
    automate_config.vm.network 'private_network', ip: '192.168.33.199'
    automate_config.vm.provider 'virtualbox' do |vb|
      vb.memory = '2048'
    end
    automate_config.vm.provision "shell", inline: "apt-get update && apt-get install -y unzip"
    automate_config.vm.provision "shell", inline: "sysctl -w vm.max_map_count=262144"
    automate_config.vm.provision "shell", inline: "sysctl -w vm.dirty_expire_centisecs=20000"
  end
end
