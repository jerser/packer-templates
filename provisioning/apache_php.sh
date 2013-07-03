#!/bin/bash

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum --enablerepo=remi,remi-test -y install httpd php php-common
yum --enablerepo=remi,remi-test -y install php-pecl-apc php-cli php-pear php-pdo php-mysql php-gd php-mbstring php-mcrypt php-xml
chkconfig httpd on
service httpd start
