#!/bin/bash
pushd /vagrant/startup/software

if hash git 2>/dev/null;then
  echo git is already installed
else
  echo install git
  yum install -y git
fi

popd