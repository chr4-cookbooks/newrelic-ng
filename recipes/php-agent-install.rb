#
# Cookbook Name:: newrelic-ng
# Recipe:: php-agent-install
#
# Copyright 2013, Jeff Byrnes <jeff@evertrue.com>
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

include_recipe 'php'
include_recipe 'newrelic-ng::newrelic-repository'

# An older version (3.0) had a bug in the init scripts that when it
# shut down the daemon it would also kill dpkg as it was trying to upgrade
# let's remove the old packages before continuing
package 'newrelic-php5' do
  action :remove
  version '3.0.5.95'
end

# run newrelic-install
# waits until php agent is installed first
execute 'newrelic-install' do
  command 'newrelic-install install'
  environment 'NR_INSTALL_SILENT' => '1'
  action :nothing
  notifies :restart, "service[#{node['newrelic-ng']['app_monitoring']['php-agent']['server_service_name']}]", :delayed
end

# install/update latest php agent
package 'newrelic-php5' do
  action :upgrade
  notifies :run, 'execute[newrelic-install]', :immediately
end
