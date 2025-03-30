#!/bin/bash
#
# verified on Fedora 31, 33, 34 and Ubuntu LTS 20.04

echo this script is no longer supported
echo use minikube-setup-docker.sh to install minikube on top of recent Ubuntu workstation
echo if you want to use this script anyway, edit it to remove lines 4-9
exit

echo this script works on Fedora 31, 33, 34 and Ubuntu 20.04
echo it does NOT currently work on Fedora 32
echo it requires the machine where you run it to have 6GB of RAM or more
echo press Enter to continue
read

##########
echo ########################################
echo WARNING
echo ########################################
echo this script may give problems in VMware / MacOS environments
echo if it does, use minikube-docker-setup.sh on Ubuntu 20.04 LTS (only distro tested so far)
echo
echo press Enter to continue
read

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

# debug MYOS variable
echo MYOS is set to $MYOS

#### Fedora config
if [ $MYOS = "Fedora" ]
then
	if [ $OSVERSION = 32 ]
	then
		echo Fedora 32 is not currently supported
		exit 9
	fi
	
	sudo dnf clean all
	sudo dnf -y upgrade

	# install KVM software
	sudo dnf install @virtualization -y
	sudo systemctl enable --now libvirtd
	sudo usermod -aG libvirt `id -un`
fi

### Ubuntu config
if [ $MYOS = "Ubuntu" ]
then
	sudo apt-get update -y 
	sudo apt-get install -y apt-transport-https curl
	sudo apt-get upgrade -y
	sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

	sudo adduser `id -un` libvirt
	sudo adduser `id -un` kvm
fi

# install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# install minikube
echo downloading minikube, check version
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo chmod +x minikube
sudo mv minikube /usr/local/bin

# adds current user to libvirt group
echo adding `id -un` to the group 'libvirt'
sudo usermod -aG libvirt `id -un`


# start minikube
minikube start --memory 4096 --vm-driver=kvm2

echo if this script ends with an error, restart the virtual machine
echo and manually run minikube start --memory 4096 --vm-driver=kvm2
