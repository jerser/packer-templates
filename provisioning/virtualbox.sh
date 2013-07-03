#!/bin/bash

yum -y install virt-what

if [ `virt-what` == "virtualbox" ]; then
  yum -y install kernel-devel kernel-headers gcc make
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
  yum -y install dkms
  export KERN_DIR=/usr/src/kernels/`uname -r`
  mkdir /mnt/VBoxGuestAdditions
  mount -o loop VBoxGuestAdditions.iso /mnt/VBoxGuestAdditions
  /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run
  umount /mnt/VBoxGuestAdditions
  rmdir /mnt/VBoxGuestAdditions
fi

rm -f VBoxGuestAdditions.iso
