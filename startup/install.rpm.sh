#!/bin/bash
pushd /vagrant/startup/software

url=$1
if [ $url = "" ];then
  echo enter package url...
  read url
fi

packagefile=${url##*/}
package=${packagefile%\.*}
name=${package%%-*}
# ------------------------------------------install package--------------------------------------
if [ "`rpm -q $name`" = "${package}" ];then
  echo $package has been installed already.
else
  echo start to install $package.
  if [ ! -f $packagefile ];then
    echo download $packagefile from $url
    wget $url
  fi
  rpm -i $packagefile
  echo $name $version is installed.
fi

popd