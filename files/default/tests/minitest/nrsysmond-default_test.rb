#
# Cookbook Name:: newrelic-ng
# Test:: nrsysmond-default
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

describe 'newrelic-ng::nrsysmond-default' do
  include Helpers::TestHelper

  it 'installs newrelic-sysmond package' do
    package('newrelic-sysmond').must_be_installed
  end

  it 'sets license key' do
    file(node['newrelic-ng']['nrsysmond']['config_file']).must_include('1234567890123456789012345678901234567890')
  end

  it 'starts newrelic-sysmond service' do
    # service status doesn't work, so grepping process table instead
    cmd = shell_out('ps aux |grep -v grep |grep -q rsysmond')
    cmd.exitstatus.to_s.must_include('0')
  end

  it 'enables newrelic-sysmond service' do
    service('newrelic-sysmond').must_be_enabled
  end
end
