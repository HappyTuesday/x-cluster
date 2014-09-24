#!/bin/bash
pushd /vagrant/startup

if hash uuid 2>/dev/null;then
  echo uuid has been installed already.
else
  yum install -y uuid libxslt
fi
./install.rpm.sh http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/postgresql93-libs-9.3.5-1PGDG.rhel6.x86_64.rpm

./install.rpm.sh http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/postgresql93-9.3.5-1PGDG.rhel6.x86_64.rpm

./install.rpm.sh http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/postgresql93-server-9.3.5-1PGDG.rhel6.x86_64.rpm

./install.rpm.sh http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/postgresql93-contrib-9.3.5-1PGDG.rhel6.x86_64.rpm

service postgresql-9.3 initdb
service postgresql-9.3 start
chkconfig postgresql-9.3 on

su - postgres
echo -e "ALTER USER postgres WITH PASSWORD 'postgres';\n\\q" | psql

popd