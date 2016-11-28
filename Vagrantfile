# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant file to be used with CF Offline Demo.
USERNAME = "Subscription_Username"
PASSWORD = "Subscription_Password"
POOL_ID = "Pool_ID"
DOWNLOAD_URL = "10.9.62.89"

# Number of virtualized CPUs
VM_CPU = ENV['VM_CPU'] || 4
# Amount of available RAM
VM_MEMORY = ENV['VM_MEMORY'] || 6144
# File to use as storage for second Virtualbox disk.
vbox_second_disk = '/$CF_SECOND_DISK/cfdb.vdi'

Vagrant.configure(2) do |config|
# Red Hat subscription details.
  config.registration.username = USERNAME
  config.registration.password = PASSWORD
  config.registration.auto_attach = false
  config.registration.pools = POOL_ID
  config.registration.unregister_on_halt = false

  config.vm.box = "CFME-Demo"
#  config.vm.box_url = "http://#{DOWNLOAD_URL}/cfme_latest_vbox.box"
  config.vm.box_url = "http://#{DOWNLOAD_URL}/cfme_latest_libv.box"

  config.ssh.insert_key = false
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.define "CFME-Demo" do |rhel|
    rhel.vm.hostname = "cloudforms.example.com"
    rhel.vm.provision :shell, :path => "http://#{DOWNLOAD_URL}/post_config.sh"
    rhel.vm.provision :shell, :path => "http://#{DOWNLOAD_URL}/database_import.sh"
      rhel.vm.provider "virtualbox" do |v, override|  
        v.memory = VM_MEMORY  
        v.cpus = VM_CPU  
        v.customize ["modifyvm", :id, "--ioapic", "on"]  
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] 
        unless File.exist?(vbox_second_disk)
          v.customize ['createhd', '--filename', vbox_second_disk, '--variant', 'Fixed', '--size', 20 * 1024]
          v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', vbox_second_disk]
        end
    end
      rhel.vm.provider "libvirt" do |v, override|
        v.memory = VM_MEMORY
        v.cpus = VM_CPU
        v.driver = "kvm"
        v.uri = "qemu:///system"
        v.storage_pool_name= "default"
        v.storage :file, :size => '20g'
    end
  end
end
