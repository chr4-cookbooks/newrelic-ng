#
# Cookbook Name:: newrelic-ng
# Test:: plugin-agent-default
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

require File.expand_path('../support/helpers', __FILE__)

describe 'newrelic-ng::plugin-agent-default' do
  include Helpers::TestHelper

  it 'installs postgresql development package' do
    package('libpq-dev').must_be_installed        if node['platform_family'] == 'debian'
    package('postgresql-devel').must_be_installed if node['platform_family'] == 'rhel'
  end

  it 'installs python dependencies' do
    cmd = shell_out('pip list |grep -q psycopg2')
    cmd.exitstatus.to_s.must_include('0')
  end

  it 'installs plugin-agent' do
    file(which('newrelic-plugin-agent')).must_exist
  end

  it 'sets license key' do
    file(node['newrelic-ng']['plugin-agent']['config_file']).must_include('1234567890123456789012345678901234567890')
  end

  it 'starts newrelic-plugin-agent service' do
    # we need to wait for a bit till service comes up
    cmd = shell_out('sleep 3; service newrelic-plugin-agent status')
    cmd.exitstatus.to_s.must_include('0')
  end

  it 'enables newrelic-plugin-agent service' do
    service('newrelic-plugin-agent').must_be_enabled
  end
end
