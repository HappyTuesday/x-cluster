#!/bin/bash
pushd /vagrant/startup

if hash gitlab 2>/dev/null && gitlab -v | grep -q 'gitlab 7.2.1';then
  echo gitlab 7.2.1 is already installed
else
  echo install gitlab 

  yum install -y openssh-server
  yum install -y postfix
  service postfix start
  chkconfig postfix on
  
  ./install.rpm.sh https://downloads-packages.s3.amazonaws.com/centos-6.5/gitlab-7.2.1_omnibus-1.el6.x86_64.rpm
fi

popd