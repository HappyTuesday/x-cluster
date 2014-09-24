#!/usr/bin/ruby

require 'yaml'

# prepare config
conffile = '/vagrant/config.yaml'
conf=nil
File.open(conffile) do|file|
  conf = YAML.load(file)
end

domain = conf['domain']
ipzone = conf['ipzone']
rule_seq = '2014091401'
dns_node = conf['nodes'].find{|x|x['type']=='dns'}
web_node = conf['nodes'].find{|x|x['type']=='web'}

named_conf_content = <<EOF
options{
  directory "/var/named";
  forward first;
  forwarders {#{conf['outerdns']};};
};

zone "." IN {
  type hint;
  file "named.ca";
};

zone "localhost" IN {
  type master;
  file "localhost.zone";
};

zone "0.0.127.in-addr.arpa" IN {
  type master;
  file "localhost.resv";
};

zone "#{domain}" IN {
  type master;
  file "#{domain}.zone";
};

zone "#{ipzone.split('.').reverse.join('.')}.in-addr.arpa" IN {
  type master;
  file "#{domain}.resv";
};
EOF

localhost_zone_content = <<EOF
$TTL 86400
@           IN SOA  localhost. admin.localhost. (
                    #{rule_seq}
                    1H
                    10M
                    7D
                    1D
)

            IN NS   localhost.
localhost.  IN A    127.0.0.1
EOF

localhost_resv_content = <<EOF
$TTL 86400
@           IN SOA  localhost. admin.localhost. (
                    #{rule_seq}
                    1H
                    10M
                    7D
                    1D
)

@           IN NS   localhost.
1.          IN PTR  localhost
EOF

rulename = "ns.#{domain}."

customer_zone_content = <<EOF
$TTL 1200
@           IN SOA  #{rulename} admin.#{domain}. (
                    #{rule_seq}
                    1H
                    10M
                    7D
                    1D
)

            IN NS   #{rulename}
#{rulename} IN A    #{ipzone}.#{dns_node['ip']}
#{
conf['nodes'].map{|node|
"#{node['name']}.#{domain}.   IN A   #{ipzone}.#{node['ip']}
"
}.join
}
wwww.#{domain}.   IN CNAME #{web_node['name']}.#{domain}
EOF

customer_resv_content = <<EOF
$TTL 1200
@           IN SOA  #{rulename} admin.#{domain}. (
                    #{rule_seq}
                    1H
                    10M
                    7D
                    1D
)

@           IN NS   #{rulename}
#{dns_node['ip']}. IN PTR    #{rulename}
#{
conf['nodes'].map{|node|
"#{node['ip']}.  IN PTR   #{node['name']}.#{domain}.
"
}.join
}
EOF

File.open('/etc/named.conf','w+') do|file|
  file << named_conf_content
end

File.open('/var/named/localhost.zone','w+') do|file|
  file << localhost_zone_content
end

File.open('/var/named/localhost.resv','w+') do|file|
  file << localhost_resv_content
end

File.open("/var/named/#{domain}.zone",'w+') do|file|
  file << customer_zone_content
end

File.open("/var/named/#{domain}.resv",'w+') do|file|
  file << customer_resv_content
end

exec 'service named restart'

puts "dns configration has been initialized"