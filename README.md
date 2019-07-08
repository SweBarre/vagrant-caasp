# vagrant-caasp -- BETA
An attempt to automate SUSE CaaS Platform v4 deployments for testing
This project is a work in progress and will be cleaned up after some testing and feedback

# What you get
* (1-2) Load balancers
* (1-3) Masters
* (1-5) Workers
* (1) Storage node setup with an NFS export for the nfs-client storage provisioner
* (1) Kubernetes Dashboard deployment

# ASSUMPTIONS
* You're running OpenSUSE Leap 15+
* You have at least 8GB of RAM to spare
* You have the ability to run VMs with KVM
* You have an internet connection (images pull from internet)
* DNS works on your system hosting the virtual machines (if getent hosts \`hostname -s\` hangs, you will encounter errors)
* You enjoy troubleshooting :P

# INSTALLATION (As root)
```sh
sysctl -w net.ipv6.conf.all.disable_ipv6=1 # rubygems.org has had issues pulling via IPv6
git clone https://github.com/sigsteve/vagrant-caasp
cd vagrant-caasp
./libvirt_setup/openSUSE_vagrant_setup.sh
```

# NETWORK SETUP (As root)
```sh
# Fresh vagrant-libvirt setup
virsh net-create ./libvirt_setup/vagrant-libvirt.xml
# _or_ if you already have the vagrant-libvirt network
./libvirt_setup/add_hosts_to_net.sh
```

# ADD BOX (As root)
```sh
vagrant box add sle15sp1 /path/to/sle15sp1.box
# NOTE: Box will be in OBS once some kiwi gets pending fixes
```

# OPTIONAL -- running as a user other than root
```sh
# Become root
echo "someuser ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/someuser
# Add user to libvirt group
usermod --append --groups libvirt someuser
su - someuser
vagrant plugin install vagrant-libvirt
# ssh-keygen if you don't have one already
ssh-copy-id root@localhost
# Add any boxes (if you have boxes installed as other users, you'll need to add them here)
vagrant box add [boxname] /path/to/boxes
```

# USAGE
Create a copy of caasp_env.conf.template and name it caasp_env.conf and copy Vagrantfile.template and name it Vagrantfile
Examine the caasp_env.conf and Vagrantfile to validate the number of nodes and memory settings

```sh
# TO START
cd vagrant-caasp
./deploy_caasp.sh < --full >
# --full will attempt to bring the machines up and deploy the cluster, based on settings in caasp_env.conf
# Please adjust your memory settings in the Vagrantfile for each machine type
# Do not run vagrant up, unless you know what you're doing and want the result
```

# INSTALLING CAASP (one step at a time)
```sh
vagrant ssh caasp4-master-1
sudo su - sles
cd /vagrant/deploy
# source this
. ./00.prep_environment
# skuba init
./01.init_cluster.sh
# skuba bootstrap (setup caasp4-master-1)
./02.bootstrap_cluster.sh
# add extra masters (if masters > 1)
./03.add_masters.sh
# add workers
./04.add_workers.sh
# setup helm
./05.setup_helm.sh
# wait for tiller to come up... Can take a few minutes.
# add NFS storage class (via helm)
./06.add_k8s_nfs-sc.sh
# add Kubernetes Dashboard
./07.add_dashboard.sh
```
# INSTALLING CAASP (all at once)
```sh
vagrant ssh caasp4-master-1
sudo su - sles
cd /vagrant/deploy
./99.run-all.sh
```
# EXAMPLES
* FULL DEPLOY
[![asciicast](https://asciinema.org/a/xN9su72gEJpaoxCZ5a97qPVEP.svg)](https://asciinema.org/a/xN9su72gEJpaoxCZ5a97qPVEP)

* INSTALL

* DESTROY

# NOTES


