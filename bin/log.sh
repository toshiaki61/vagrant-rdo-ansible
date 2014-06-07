#!/bin/sh
sudo cat /var/log/ceilometer/* > /vagrant/tmp/log/ceilometer.log
sudo cat /var/log/cinder/* > /vagrant/tmp/log/cinder.log
sudo cat /var/log/cron/* > /vagrant/tmp/log/cron.log
sudo cat /var/log/glance/* > /vagrant/tmp/log/glance.log
sudo cat /var/log/heat/* > /vagrant/tmp/log/heat.log
sudo cat /var/log/horizon/* > /vagrant/tmp/log/horizon.log
sudo cat /var/log/httpd/* > /vagrant/tmp/log/httpd.log
sudo cat /var/log/keystone/* > /vagrant/tmp/log/keystone.log
sudo cat /var/log/messages/* > /vagrant/tmp/log/messages.log
sudo cat /var/log/mongodb/* > /vagrant/tmp/log/mongodb.log
sudo cat /var/log/neutron/* > /vagrant/tmp/log/neutron.log
sudo cat /var/log/nova/* > /vagrant/tmp/log/nova.log