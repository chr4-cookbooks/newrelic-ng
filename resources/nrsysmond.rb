#
# Cookbook Name:: newrelic-ng
# Resource:: nrsysmond
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

actions        :configure
default_action :configure

attribute :license_key,    kind_of: String, name_attribute: true
attribute :ssl,            kind_of: [TrueClass, FalseClass], default: node['newrelic-ng']['nrsysmond']['config']['ssl']
attribute :loglevel,       kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['loglevel']
attribute :logfile,        kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['logfile']
attribute :proxy,          kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['proxy']
attribute :ssl_ca_bundle,  kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['ssl_ca_bundle']
attribute :ssl_ca_path,    kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['ssl_ca_path']
attribute :pidfile,        kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['pidfile']
attribute :collector_host, kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['collector_host']
attribute :timeout,        kind_of: Integer, default: node['newrelic-ng']['nrsysmond']['config']['timeout']
attribute :hostname,       kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['hostname']
attribute :labels,         kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config']['labels']

attribute :owner,          kind_of: String,  default: 'root'
attribute :group,          kind_of: String,  default: node['newrelic-ng']['user']['group']
attribute :config_file,    kind_of: String,  default: node['newrelic-ng']['nrsysmond']['config_file']
attribute :mode,           kind_of: [Integer, String], default: node['newrelic-ng']['nrsysmond']['mode']

attribute :cookbook,       kind_of: String,  default: 'newrelic-ng'
attribute :source,         kind_of: String,  default: 'nrsysmond.cfg.erb'
