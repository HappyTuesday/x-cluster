#!/bin/bash
pushd /vagrant/startup

echo install util tools

yum install -y \
  cpp gcc gcc-c++ make autoconf automake \
  patch readline-devel zlib-devel libffi-devel openssl-devel libtool bison

popd