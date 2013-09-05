#
# Cookbook Name:: newrelic-ng
# Recipe:: repository
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

apt_repository 'newrelic' do
  uri          node['newrelic-ng']['nrsysmond']['apt']['repo']['url']
  distribution node['newrelic-ng']['nrsysmond']['apt']['repo']['distribution']
  components   node['newrelic-ng']['nrsysmond']['apt']['repo']['components']
  key          node['newrelic-ng']['nrsysmond']['apt']['repo']['key']
  only_if    { node['platform_family'] == 'debian' }
end

if node['platform_family'] == 'rhel'
  rpm_path = "#{Chef::Config[:file_cache_path]}/#{::File.basename(node['newrelic-ng']['nrsysmond']['rpm']['repo']['package'])}"

  remote_file rpm_path do
    source node['newrelic-ng']['nrsysmond']['rpm']['repo']['url']
    action :create_if_missing
  end

  package node['newrelic-ng']['nrsysmond']['rpm']['repo']['package'] do
    provider Chef::Provider::Package::Rpm
    source   rpm_path
    action   :install
  end
end
