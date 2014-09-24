#!/bin/bash
pushd /vagrant/startup

yum install -y libyaml
./install.rpm.sh ftp://rpmfind.net/linux/sourceforge/c/cr/crowbar/core/trunk/ruby-2.1.2-2.el6.x86_64.rpm

popd