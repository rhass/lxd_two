#
# Cookbook:: lxd_two
# Recipe:: configure
#
# Copyright:: 2017, Ryan Hass
# Copyright:: 2017, Chef Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# LXD Production Server Tuning
# https://github.com/lxc/lxd/blob/master/doc/production-setup.md
file '/etc/security/limits.d/60-lxd.conf' do
  owner 'root'
  group 'root'
  mode 0644
  content <<EOF
# ***
# * THIS FILE WAS CREATED AND IS MANAGED BY CHEF
# * Cookbook:: #{cookbook_name}
# * Recipe:: #{recipe_name}
# ***
#<domain>      <type>  <item>         <value>
*              soft    nofile         1048576
*              hard    nofile         1048576
root           soft    nofile         1048576
root           hard    nofile         1048576
*              soft    memlock        unlimited
*              hard    memlock        unlimited
EOF
end

file '/etc/sysctl.d/60-lxd.conf' do
  owner 'root'
  group 'root'
  mode 0644
  content <<EOF
# ***
# * THIS FILE WAS CREATED AND IS MANAGED BY CHEF
# * Cookbook:: #{cookbook_name}
# * Recipe:: #{recipe_name}
# ***
fs.inotify.max_queued_events=1048576
fs.inotify.max_user_instances=1048576
fs.inotify.max_user_watches=1048576
vm.max_map_count=262144
kernel.dmesg_restrict=1
net.core.netdev_max_backlog=#{Mixlib::ShellOut.new('sysctl net.ipv4.tcp_mem').run_command.stdout.split[2]}
EOF
end

# Reload sysctl files when creating or modifying the conf.
execute 'apply_sysctl_settings' do
  command 'sysctl --system'
  action :nothing
  subscribes :run, 'file[/etc/sysctl.d/60-lxd.conf]'
end

require 'yaml'
lxd_preseed = ::File.join(Chef::Config['file_cache_path'], 'lxd-preseed.yml')
file lxd_preseed do
  owner 'root'
  mode 0600
  content node['lxd']['preseed'].to_hash.to_yaml
  sensitive true
end

execute 'lxd_init' do
  command "cat #{lxd_preseed} | lxd init --preseed"
  action :nothing
  subscribes :run, "file[#{lxd_preseed}]"
end
