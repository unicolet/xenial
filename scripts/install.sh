#!/usr/bin/env bash

# @ VirtualBox @

export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt-get -y upgrade
sudo apt install -y ansible linux-headers-$(uname -r) build-essential \
     dkms apt-transport-https \
     wget curl jq \
     ca-certificates git \
     linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions
rm /home/vagrant/VBoxGuestAdditions.iso

# @ Java @

#add-apt-repository -y ppa:webupd8team/java
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" |    debconf-set-selections
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
#apt-get update
#apt-get install -y oracle-java8-installer maven

# @ Docker @
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce

# @ Utils @
sudo pip install ansible==2.2.1.0

# @ Filebeat @

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update
sudo apt-get install filebeat

# @ Clean up @
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*