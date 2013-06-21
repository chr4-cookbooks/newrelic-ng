#
# Cookbook Name:: newrelic-ng
# Attributes:: default
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

# server monitoring
default['newrelic-ng']['nrsysmond']['config'] = {
  'license_key' => 'CHANGE_ME',
  'loglevel' => 'info',
  'logfile' => '/var/log/newrelic/nrsysmond.log',
  'proxy' => nil,
  'ssl' => true,
  'ssl_ca_bundle' => nil,
  'ssl_ca_path' => nil,
  'pidfile' => nil,
  'collector_host' => nil,
  'timeout' => nil,
}

default['newrelic-ng']['nrsysmond']['config_file'] = '/etc/newrelic/nrsysmond.cfg'
default['newrelic-ng']['nrsysmond']['owner'] = 'root'
default['newrelic-ng']['nrsysmond']['group'] = 'newrelic'
default['newrelic-ng']['nrsysmond']['mode'] = 00640

default['newrelic-ng']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i386'
default['newrelic-ng']['nrsysmond']['rpm']['repo']['url'] =  "http://download.newrelic.com/pub/newrelic/el5/#{node['newrelic-ng']['arch']}/newrelic-repo-5-3.noarch.rpm"
default['newrelic-ng']['nrsysmond']['rpm']['repo']['package'] = 'newrelic-repo'

default['newrelic-ng']['nrsysmond']['apt']['repo']['url'] = 'http://apt.newrelic.com/debian/'
default['newrelic-ng']['nrsysmond']['apt']['repo']['distribution'] = 'newrelic'
default['newrelic-ng']['nrsysmond']['apt']['repo']['components'] = [ 'non-free' ]
default['newrelic-ng']['nrsysmond']['apt']['repo']['key'] = 'http://download.newrelic.com/548C16BF.gpg'


# plugin-agent
default['newrelic-ng']['plugin-agent']['license_key'] = 'CHANGE_ME'
default['newrelic-ng']['plugin-agent']['poll_interval'] = 60
default['newrelic-ng']['plugin-agent']['pidfile'] = '/var/run/newrelic/newrelic_plugin_agent.pid'
default['newrelic-ng']['plugin-agent']['logfile'] = '/var/log/newrelic/newrelic_plugin_agent.log'
default['newrelic-ng']['plugin-agent']['service_config'] = ''

default['newrelic-ng']['plugin-agent']['config_file'] = '/etc/newrelic/newrelic_plugin_agent.cfg'
default['newrelic-ng']['plugin-agent']['owner'] = 'newrelic'
default['newrelic-ng']['plugin-agent']['group'] = 'newrelic'
default['newrelic-ng']['plugin-agent']['mode'] = 00640
default['newrelic-ng']['plugin-agent']['pip_package'] = 'newrelic-plugin-agent'

