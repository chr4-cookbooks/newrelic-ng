#
# Cookbook Name:: newrelic-ng
# Provider:: php_agent
#
# Copyright 2013, Jeff Byrnes <jeff@evertrue.com>
#
# This program is free software: you can redistribute it and/or modunlessy.empty?
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
  service 'newrelic-daemon' do
    supports status: true, start: true, stop: true, restart: true
  end

  # ensure that the file #{new_resource.daemon_upgrade_file}
  # does not exist if it does, move it aside (or remove it)
  execute 'newrelic-backup-key' do
    command "mv #{new_resource.daemon_upgrade_file} #{new_resource.daemon_upgrade_file}.external"
    only_if { ::File.exist?(new_resource.daemon_upgrade_file) }
  end

  # https://newrelic.com/docs/php/newrelic-daemon-startup-modes
  Chef::Log.info("newrelic-daemon startup mode: #{new_resource.startup_mode}")

  case new_resource.startup_mode
  when 'agent'
    # agent startup mode

    # ensure that the daemon isn't currently running
    service 'newrelic-daemon' do
      # stops the service if it's running and disables it from
      # starting at system boot time
      action [:disable, :stop]
    end

    # ensure that the file #{new_resource.daemon_config_file} does
    # not exist if it does, move it aside (or remove it)
    execute 'newrelic-backup-cfg' do
      command "mv #{new_resource.daemon_config_file} #{new_resource.daemon_config_file}.external"
      only_if { ::File.exist?(new_resource.daemon_config_file) }
    end
  when 'external'
    # external startup mode

    # configure proxy daemon settings
    daemon_config = template new_resource.daemon_config_file do
      cookbook  new_resource.cookbook
      source    new_resource.source_cfg
      owner     new_resource.owner
      group     new_resource.group
      mode      new_resource.mode

      variables config: new_resource

      notifies :restart, 'service[newrelic-daemon]', :immediately
      notifies :restart, "service[#{new_resource.server_service_name}]", :delayed
    end

    new_resource.updated_by_last_action(true) if daemon_config.updated_by_last_action?

    service 'newrelic-daemon' do
      # start the service if it's not running and enable it to start at system boot time
      action [:enable, :start]
    end
  else
    Chef::Application.fatal!("#{new_resource.startup_mode} is not a valid newrelic-daemon startup mode.")
  end

  # configure New Relic INI file and set the daemon related options
  # (documented at /usr/lib/newrelic-php5/scripts/newrelic.ini.template)
  # and restart the web server in order to pick up the new settings
  php_config = template new_resource.config_file do
    cookbook  new_resource.cookbook
    source    new_resource.source
    owner     new_resource.owner
    group     new_resource.group
    mode      new_resource.mode

    variables config: new_resource

    notifies :restart, "service[#{new_resource.server_service_name}]", :delayed
  end

  new_resource.updated_by_last_action(true) if php_config.updated_by_last_action?
end
