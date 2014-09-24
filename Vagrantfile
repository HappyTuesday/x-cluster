# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'

# common defines
current_dir = File.dirname(__FILE__)
conf = nil

# prepare config
File.open("#{current_dir}/config.yaml") do|file|
  conf=YAML.load(file)
end

dns_node = conf['nodes'].find{|x|x['type']=='dns'}
memory = conf['memory']
box_url = "file:///E:/system/Linux/Vagrant/boxes/#{conf['box_name']}"
account = conf['account']
domain = conf['domain']
ipzone = conf['ipzone']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  conf['nodes'].each do |node|
    nodename = node['name']
    nodetype = if node.include? 'type' then node['type'] else 'normal' end
    config.vm.define nodename.to_sym do |vmconfig|
      vmconfig.vm.box = nodename
      vmconfig.vm.box_url = box_url
      vmconfig.vm.hostname = "#{nodename}.#{domain}"
      vmconfig.vm.network 'public_network', bridge: 'eth1', :ip => "#{ipzone}.#{node['ip']}"
      
      vmconfig.vm.provision "shell", path: "startup/sysinit.sh", args: [nodetype,account['name'],account['password'],"#{ipzone}.#{dns_node['ip']}","http://git.#{domain}"]
      
      vmconfig.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "#{memory}"]
      end
    end
  end
end
