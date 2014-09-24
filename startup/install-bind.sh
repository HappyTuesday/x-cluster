#!/bin/bash
pushd /vagrant/startup

# ------------------------------------------install bind--------------------------------------
if hash named 2>/dev/null;then
  echo named is already installed
else
  yum install bind -y
  yum install bind-utils -y
  rndc-confgen -r /dev/urandom -a
  chkconfig named on
fi

popd