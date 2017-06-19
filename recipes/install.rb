#
# Cookbook:: lxd_two
# Recipe:: install
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

apt_update

package 'lxd' do
  default_release "#{node['lsb']['codename']}-backports" if plaform?('ubuntu') && node['platform_version'] == '16.04'
  action [:install, :upgrade]
end

service 'lxd' do
  action [:enable, :start]
end
