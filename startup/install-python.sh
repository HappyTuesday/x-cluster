#!/bin/bash
pushd /vagrant/startup/software

if hash python3.4 2>/dev/null && python3.4 --version | grep -q 'python 3.4.1';then
  echo python 3.4.1 is already installed
else
  yum install -y xz
  echo install python 3.4.1
  python_package=Python-3.4.1
  python_package_fullname=$python_package.tar
  [ -f $python_package_fullname.xz ] || wget -o $python_package_fullname.xz https://www.python.org/ftp/python/3.4.1/Python-3.4.1.tar.xz
  xz -dfk $python_package_fullname.xz
  tar xvf $python_package_fullname
  cd $python_package
  ./configure
  make && make install
fi

popd