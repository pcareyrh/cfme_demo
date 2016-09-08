# -*- mode: ruby -*-
# vi: set ft=ruby :

# Number of virtualized CPUs
VM_CPU = ENV['VM_CPU'] || 4
# Amount of available RAM
VM_MEMORY = ENV['VM_MEMORY'] || 6144

disk = '/home/pcarey/VirtualMachines/disks/cfdb.vdi'

Vagrant.configure(2) do |config|
  config.registration.username = "pcarey@redhat.com"
  config.registration.password = "device$defy"
  config.registration.auto_attach = false
#  config.registration.pools = "8a85f981568e999d01568ed2241a67c2"
  config.registration.unregister_on_halt = false

  config.vm.box = "vagrant-cfme-box"
  config.ssh.insert_key = false
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provision "file", source: "/home/pcarey/Downloads/cloudformsDatabase4.1.005.db", destination: "/home/vagrant/cloudformsDatabase4.1.005.db"
  config.vm.provision "file", source: "/home/pcarey/Downloads/v2_key", destination: "/home/vagrant/v2_key"

  config.vm.define "vm" do |rhel|
    rhel.vm.hostname = "cloudforms.example.com"
    rhel.vm.provision :shell, :path => "post.sh"
      rhel.vm.provider "virtualbox" do |v, override|  
        v.memory = VM_MEMORY  
        v.cpus = VM_CPU  
        v.customize ["modifyvm", :id, "--ioapic", "on"]  
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]  
    end
      rhel.vm.provider "vagrant-libvirt" do |v, override|
        v.memory = 2048
        v.cpus = 4
        v.driver = "kvm"
        v.driver = "kvm"
        v.uri = "qemu:///system"
        v.storage_pool_name= "default"
        v.storage :file, :size => '5g'
    end
  end
end
#      unless File.exist?(disk)
 #       v.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 5 * 1024]
#      end
 #     v.customize ['storageattach', :id,  '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
#
