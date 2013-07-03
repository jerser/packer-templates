#!/bin/bash

yum -y install mysql-server
chkconfig mysqld on
service mysqld start
