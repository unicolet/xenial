#!/usr/bin/env bash

# @ VirtualBox @

export DEBIAN_FRONTEND=noninteractive
sudo apt update
apt-get -y upgrade
sudo apt install -y ansible linux-headers-$(uname -r) build-essential \
     dkms apt-transport-https \
     wget curl jq \
     ca-certificates

sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions
rm /home/vagrant/VBoxGuestAdditions.iso

# @ Java @

#add-apt-repository -y ppa:webupd8team/java
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
#apt-get update
#apt-get install -y oracle-java8-installer maven

# @ Docker @
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
apt-get install -y docker-engine
apt-get install -y git

service docker start
docker run hello-world

# @ Utils @
pip install awscli
pip install ansible

# @ Filebeat @

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get update
apt-get install filebeat