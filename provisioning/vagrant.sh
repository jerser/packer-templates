#!/bin/bash

if [ `virt-what` == "virtualbox" ]; then
  date > /etc/vagrant_box_build_time

  useradd -m vagrant
  echo -e "vagrant\nvagrant" | (passwd --stdin vagrant)

  echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  echo "Defaults:vagrant !requiretty" >> /etc/sudoers

  mkdir -m 777 /vagrant
  mkdir -m 700 /home/vagrant/.ssh
  curl -L https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
  chmod 0600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant.vagrant /home/vagrant/.ssh
fi
