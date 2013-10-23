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

default['newrelic-ng']['license_key'] = 'CHANGE ME'

default['newrelic-ng']['user']['name']   = 'newrelic'
default['newrelic-ng']['user']['group']  = 'newrelic'
default['newrelic-ng']['user']['shell']  = '/bin/sh'
default['newrelic-ng']['user']['system'] = true

default['newrelic-ng']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i386'
