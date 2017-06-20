#!/usr/bin/env bash

set -x

# @ VirtualBox and base packages @
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get update
sudo -E apt-get -y upgrade
sudo -E apt-get install -y linux-headers-$(uname -r) build-essential \
     dkms apt-transport-https \
     linux-image-extra-$(uname -r) \
     linux-image-extra-virtual

sudo -E apt-get install -y ansible libssl-dev \
     wget curl jq \
     ca-certificates git \
     software-properties-common \
     python-pip

sudo -E mkdir /media/VBoxGuestAdditions
sudo -E mount -o loop,ro /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo -E sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
sudo -E umount /media/VBoxGuestAdditions
sudo -E rmdir /media/VBoxGuestAdditions
rm -f /home/vagrant/VBoxGuestAdditions.iso

# @ Java @

#add-apt-repository -y ppa:webupd8team/java
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" |    debconf-set-selections
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
#apt-get update
#apt-get install -y oracle-java8-installer maven

# @ Docker @
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -
sudo -E add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo -E apt-get update
sudo -E apt-get install -y docker-ce

# @ Ansible @
# uninstall system ansible
sudo -E apt-get remove -y ansible
sudo -E pip install --upgrade ansible==2.2.1.0

# @ Filebeat @

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo -E apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo -E tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo -E apt-get update
sudo -E apt-get install -y filebeat

# @ Vagrant insecure key @
mkdir .ssh
wget -O - https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

# @ Clean up @
sudo -E apt-get autoremove -y
sudo -E apt-get clean
sudo -E rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*