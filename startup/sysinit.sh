#!/bin/bash

pushd ~
# ------------------------------------------initialize system--------------------------------------
# common definations
nodetype=$1
username=$2
password=$3
dns_ip=$4
input_ports=(21 22 53 80)

echo prepare parameters
[ "$username" != "" ] || username="x"
[ "$password" != "" ] || password="abc123_"
[ "$dns_ip" != "" ] || dns_ip=192.168.1.200
if [ "$nodetype" = "" ];then
  echo please enter node type
  read nodetype
fi

echo setup account
if [ ! -d /home/$username ];then
	useradd $username
	echo -e "$password\n$password" | passwd $username
fi

echo add user $username to sudoers
sudoer="$username  ALL=(ALL) ALL"
cat /etc/sudoers | grep -q "$sudoer" || echo "$sudoer" >> /etc/sudoers

echo copy rsa public key and private key
cd /home/$username
[ -d .ssh ] || mkdir .ssh
chown $username .ssh
cp -f /vagrant/ssh/authorized_keys .ssh
cp -f /vagrant/ssh/id_rsa .ssh
chmod 400 .ssh/id_rsa.ssh

echo update yum repository
cd /vagrant/startup
./install.rpm.sh ftp://rpmfind.net/linux/centos/6.5/extras/x86_64/Packages/epel-release-6-8.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
yum clean all
yum makecache

echo install common tools
yum install -y vim man tree

echo common configurations
cp -f /vagrant/startup/resources/.vimrc /home/$username/.vimrc
cd /home/$username
[ ! -d .vim ] || mkdir -p .vim
cp -f /vagrant/startup/resources/colors .vim
cp -f /vagrant/startup/resources/plugin .vim

echo update iptables
iptables -F
iptables -X
for port in ${input_ports[@]};do
  iptables -A INPUT -p tcp --dport $port -j ACCEPT
done
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -p all -j ACCEPT
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
/etc/rc.d/init.d/iptables save
service iptables restart

cd /vagrant/startup
echo nodetype is $nodetype
case $nodetype in
  'dns')
  ./install-util-tools.sh
  ./install-ruby.sh
  ./install-bind.sh
  ./config-dns.rb
  ;;
  'master')
  ./install-util-tools.sh
  ./install-git.sh
  ./install-postgresql.sh
  ;;
esac

echo update dns ip
cd /etc
sed -i "/nameserver/c nameserver $dns_ip" resolv.conf

cd /etc/sysconfig/network-scripts
for device in ifcfg-eth*;do
  sed -i "/^DNS1/"d $device
  echo "DNS1=\"$dns_ip\"" >> $device
done

popd
