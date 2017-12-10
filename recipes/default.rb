#
# Cookbook:: httpd
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'base::default'

package "httpd24" do
    action :install
end

service "httpd" do
    action [ :enable, :start ]
end

directory "/var/www/sites/" + node['server_name'] + "/htdocs" do
    owner "deploy"
    group "deploy"
    mode 0755
    recursive true
    action :create
end

file "/etc/httpd/conf.d/welcome.conf" do
    action :delete
end

file "/etc/httpd/conf.d/autoindex.conf" do
    action :delete
end

template "/etc/httpd/conf/httpd.conf" do
    owner "root"
    mode 0644
    source "httpd.conf.erb"
end

template "/etc/httpd/conf.d/vhost.conf" do
    owner "root"
    mode 0644
    source "vhost.conf.erb"
    notifies :restart, "service[httpd]"
end

group "deploy" do
    action :modify
    members ['deploy,apache']
end
