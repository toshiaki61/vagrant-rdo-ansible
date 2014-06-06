# -*- mode: ruby -*-
# vi: set ft=ruby :

# vagrant plugin install sahara
# vagrant plugin install vagrant-cachier
# vagrant plugin install vagrant-global-status
# vagrant plugin install vagrant-omnibus
# vagrant plugin install vagrant-vbguest
# vagrant plugin install vagrant-vbox-snapshot
# http://repos.fedorapeople.org/repos/openstack/guest-images/centos-6.5-20140117.0.x86_64.qcow2

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT


SCRIPT
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos65"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  # • Controller Node: 1 processor, 2 GB memory, and 5 GB storage
  # • Network Node: 1 processor, 512 MB memory, and 5 GB storage
  # • Compute Node: 1 processor, 2 GB memory, and 10 GB storage
  config.vm.define "controller" do |box|
    box.vm.hostname = "controller"
    box.vm.network :private_network, ip: "10.0.0.11", :netmask => "255.255.255.0"
    box.vm.network :private_network, ip: "10.0.10.11", :netmask => "255.255.255.0"
    box.vm.network :forwarded_port, guest: 80, host: 8080
    box.vm.network :forwarded_port, guest: 443, host: 8443
    box.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "2048"]
      
      file_to_disk = "./tmp/controller.vdi"
      if not File.exist?(file_to_disk) then
        vbox.customize ["createhd", "--filename", file_to_disk, "--size", 5 * 1024]
      end
      vbox.customize ["storageattach", :id, "--storagectl", "SATA", "--port", 1, "--device", 0, "--type", "hdd", "--medium", file_to_disk, "--setuuid", ""]
    end
  end
  config.vm.define "network" do |box|
    box.vm.hostname = "network"
    box.vm.network :private_network, ip: "10.0.0.21", :netmask => "255.255.255.0"
    box.vm.network :private_network, ip: "10.0.10.21", :netmask => "255.255.255.0"
    box.vm.network :private_network, ip: "203.0.113.1", :netmask => "255.255.255.0", :auto_config => false
    box.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "512"]
      # eth3 must be in promiscuous mode for floating IPs to be accessible
      vbox.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    end
  end
  config.vm.define "compute1" do |box|
    box.vm.hostname = "compute1"
    box.vm.network :private_network, ip: "10.0.0.31", :netmask => "255.255.255.0"
    box.vm.network :private_network, ip: "10.0.10.31", :netmask => "255.255.255.0"
    box.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "2048"]
    end
  end
  # config.vm.define "block1" do |box|
  #   box.vm.hostname = "block1"
  #   box.vm.network :private_network, ip: "10.0.0.41", :netmask => "255.255.255.0"
  #   box.vm.network :private_network, ip: "10.0.10.41", :netmask => "255.255.255.0"
  # end
  # config.vm.define "storage1" do |box|
  #   box.vm.hostname = "storage1"
  #   box.vm.network :private_network, ip: "10.0.0.51", :netmask => "255.255.255.0"
  #   box.vm.network :private_network, ip: "10.0.10.51", :netmask => "255.255.255.0"
  # end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    #ansible.verbose = "vvvv"
    ansible.groups = {
      "controller-node" => ["controller"],
      "network-node" => ["network"],
      "compute-node" => ["compute1"],
      "block-node" => [
        # "block1",
        "controller",
      ],
      "storage-node" => [
        # "storage1",
        "controller",
      ],
      "proxy-node" => [
        "controller",
      ],
      "orchestration-node" => [
        "controller",
      ],
      "telemetry-node" => [
        "controller",
      ],
    }
  end
end