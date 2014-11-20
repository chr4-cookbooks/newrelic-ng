#
# Cookbook Name:: newrelic-ng
# Provider:: nrsysmond
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

action :configure do
  service 'newrelic-sysmond' do
    supports status: true, restart: true
    action   :enable
  end

  directory ::File.dirname(new_resource.config_file)

  r = template 'nrsysmond.cfg' do
    path      new_resource.config_file
    cookbook  new_resource.cookbook
    source    new_resource.source
    owner     new_resource.owner
    group     new_resource.group
    mode      new_resource.mode

    variables license_key:    new_resource.license_key,
              ssl:            new_resource.ssl,
              logfile:        new_resource.logfile,
              loglevel:       new_resource.loglevel,
              proxy:          new_resource.proxy,
              ssl_ca_bundle:  new_resource.ssl_ca_bundle,
              ssl_ca_path:    new_resource.ssl_ca_path,
              pidfile:        new_resource.pidfile,
              collector_host: new_resource.collector_host,
              timeout:        new_resource.timeout,
              hostname:       new_resource.hostname,
              labels:         new_resource.labels

    notifies  :restart, 'service[newrelic-sysmond]'
  end

  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
