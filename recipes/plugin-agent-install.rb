#
# Cookbook Name:: newrelic-ng
# Recipe:: plugin-agent-install
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# a compiler is required for building some of the python modules the agent requires
include_recipe 'build-essential'
include_recipe 'python'

python_pip 'newrelic-plugin-agent' do
  package_name node['newrelic-ng']['plugin-agent']['pip_package']
  action :upgrade
end

newrelic_ng_user 'default' do
  name   node['newrelic-ng']['user']['name']
  group  node['newrelic-ng']['user']['group']
  shell  node['newrelic-ng']['user']['shell']
  system node['newrelic-ng']['user']['system']
end

# create config/run/log directories
[node['newrelic-ng']['plugin-agent']['config_file'],
 node['newrelic-ng']['plugin-agent']['pidfile'],
 node['newrelic-ng']['plugin-agent']['logfile']].each do |dir|
  directory ::File.dirname(dir) do
    owner node['newrelic-ng']['user']['name']
    group node['newrelic-ng']['user']['group']
    mode  0o755
  end
end

init_script_template = value_for_platform_family(
  rhel:   'plugin-agent-init-rhel.erb',
  debian: 'plugin-agent-init-deb.erb',
)

# deploy initscript
template '/etc/init.d/newrelic-plugin-agent' do
  mode      0o755
  cookbook  'newrelic-ng'
  source    init_script_template
  variables config_file: node['newrelic-ng']['plugin-agent']['config_file'],
            user:        node['newrelic-ng']['user']['name'],
            group:       node['newrelic-ng']['user']['group']
end
