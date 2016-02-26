#
# Cookbook Name:: newrelic-ng
# Resource:: generic_agent
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

actions        :install_and_configure, :install, :configure
default_action :install_and_configure

attribute :license_key, kind_of: String, name_attribute: true
attribute :plugin_name, kind_of: String, required: true
attribute :source,      kind_of: String, required: true
attribute :config,      kind_of: String, required: true
attribute :target_dir,  kind_of: String, default: node['newrelic-ng']['generic-agent']['target_dir']

attribute :owner,       kind_of: String, default: node['newrelic-ng']['user']['name']
attribute :group,       kind_of: String, default: node['newrelic-ng']['user']['group']
attribute :shell,       kind_of: String, default: node['newrelic-ng']['user']['shell']
attribute :system,      kind_of: [TrueClass, FalseClass], default: node['newrelic-ng']['user']['system']
