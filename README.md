# Cloudforms Offline demo.

Maintainer - pcarey@redhat.com
Pull Requests welcome.

Desciption
This project has been created to provide an offline demo of the Red Hat Cloudforms appliance and import a pre-configured static database into the appliance.
The Vagrantfile will download the Virtualbox/libvirt box file and import this into vagrant. When booting this box vagrant will download two additional post-configuration scripts. These will configure some repositories and initialise the cloudforms appliance. Once successful, the second file will download the latest cloudforms offline database and import this into the appliance. 

The downloads are quite large and can take some time to complete. (Wired connection recommended). 
* Box file ~ 750MB
* Demo database ~ 1.7GB

Ideally, if time permits this offline demo can be removed from vagrant and used on demand, to save local resources.
The scripts in this file have been designed and tested using the following setup.

* Fedora 24
* Oracle VirtualBox 5.0.26
* Libvirtd 1.3.3.2
* CFME Appliance 5.6.1.2
* Vagrant 1.8.1
* Vagrant Plugins
  * vagrant-env (0.0.3)
  * vagrant-hostmanager (1.8.5, system)
  * vagrant-libvirt (0.0.35, system)
  * vagrant-registration (1.3.0, system)
* VPN connection

Variables.
The script requires the following information is entered into the Vagrantfile

Demobuilder URL (of the virtualbox or libvirt box-file)
Cloudforms database dump URL
RH Subscription details: Username, Password, PoolID.
Filename location for a second harddisk, if using VirtualBox.

The default resource requirements for the demo are:
* 4 vcpu
* 6144 MB RAM
* 40GB Primary disk
* 20GB Secondary disk. (Demo database is approximately 17GB used when imported)

