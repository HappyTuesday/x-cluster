#!/bin/bash
pushd ~

gitlab_url=$1

[ "$gitlab_url" != "" ] || gitlab_url='http://git.xrs.com'

sed -i "/^external_url/c external_url '$gitlab_url'" /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure
lokkit -s http -s ssh

#Username: root 
#Password: 5iveL!fe

popd