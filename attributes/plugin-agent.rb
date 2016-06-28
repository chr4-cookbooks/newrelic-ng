#
# Cookbook Name:: newrelic-ng
# Attributes:: plugin-agent
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

default['newrelic-ng']['plugin-agent']['poll_interval'] = 60
default['newrelic-ng']['plugin-agent']['pidfile'] = '/var/run/newrelic/newrelic-plugin-agent.pid'
default['newrelic-ng']['plugin-agent']['logfile'] = '/var/log/newrelic/newrelic-plugin-agent.log'
default['newrelic-ng']['plugin-agent']['service_config'] = ''

default['newrelic-ng']['plugin-agent']['config_file'] = '/etc/newrelic/newrelic-plugin-agent.cfg'
default['newrelic-ng']['plugin-agent']['mode'] = 0o640
default['newrelic-ng']['plugin-agent']['pip_package'] = 'newrelic-plugin-agent'
