#
# Cookbook Name:: newrelic
# Test:: php-agent-default
#
# Copyright 2013, Jeff Byrnes
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

describe 'newrelic-ng::php-agent-default' do
  include Helpers::TestHelper

  it 'installs the New Relic PHP Agent' do
    package('newrelic-php5').must_be_installed
  end

  it 'starts the New Relic daemon agent style' do
    service('newrelic-daemon').must_be_running
  end

  if node['newrelic-ng']['app_monitoring']['php-agent']['startup_mode'] == 'agent'
    it 'disables the New Relic daemon from startup init' do
      service('newrelic-daemon').wont_be_enabled
    end

    it 'removes the New Relic daemon config' do
      file(node['newrelic-ng']['app_monitoring']['daemon']['config_file']).wont_exist
    end
  else
    it 'disables the New Relic daemon from startup init' do
      service('newrelic-daemon').must_be_enabled
    end

    it 'removes the New Relic daemon config' do
      file(node['newrelic-ng']['app_monitoring']['daemon']['config_file']).must_exist
    end
  end

  it 'removes the New Relic upgrade.key' do
    file(node['newrelic-ng']['app_monitoring']['daemon']['upgrade_file']).wont_exist
  end

  it 'installs the New Relic PHP Agent config' do
    file(node['newrelic-ng']['app_monitoring']['php-agent']['config_file']).must_exist
  end

  it 'sets license key' do
    file(node['newrelic-ng']['app_monitoring']['php-agent']['config_file']).must_include('1234567890123456789012345678901234567890')
  end
end
