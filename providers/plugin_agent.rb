#
# Cookbook Name:: newrelic-ng
# Provider:: plugin_agent
#
# Copyright 2012, Chris Aumann
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
  filenames = calculate_filenames
  
  install_prerequisites
  generate_config_file filenames
  generate_init_script filenames
  start_service filenames
end

def defaulted? attribute
  new_resource.send(attribute.to_sym) == node['newrelic-ng']['plugin-agent'][attribute]
end

def install_prerequisites
  # postgresql and pgbouner need pg_config
  if new_resource.service_config.include? 'postgresql:' or
     new_resource.service_config.include? 'pgbouncer:'

    # for the `pg_config` python module to install properly, we need one of these packages
    # see stackoverflow.com/a/12037133/133479 for details
    package 'libpq-dev'        if node['platform_family'] == 'debian'
    package 'postgresql-devel' if node['platform_family'] == 'rhel'
  end

  # recent versions of plugin_agent can automatically resolv libraries needed
  python_pip 'newrelic_plugin_agent[mongodb]'    if new_resource.service_config.include? 'mongodb:'
  python_pip 'newrelic_plugin_agent[pgbouncer]'  if new_resource.service_config.include? 'pgbouncer:'
  python_pip 'newrelic_plugin_agent[postgresql]' if new_resource.service_config.include? 'postgresql:'
end

def calculate_filenames
  pidfile = if defaulted? :agent_name
              new_resource.pidfile
            elsif defaulted? :pidfile
              "/var/run/newrelic/newrelic-plugin-agent-#{new_resource.agent_name}.pid"
            else
              new_resource.pidfile
            end

  logfile = if defaulted? :agent_name
              new_resource.logfile
            elsif defaulted? :logfile
              "/var/log/newrelic/newrelic-plugin-agent-#{new_resource.agent_name}.log"
            else
              new_resource.logfile
            end

  config_file = if defaulted? :agent_name
                  new_resource.logfile
                elsif defaulted? :config_file
                  "/etc/newrelic/newrelic-plugin-agent-#{new_resource.agent_name}.cfg"
                else
                  new_resource.config_file
                end

  service_name = if defaulted? :agent_name
                   'newrelic-plugin-agent'
                 else
                   "newrelic-plugin-agent-#{new_resource.agent_name}"
                 end

  {
      pidfile: pidfile,
      logfile: logfile,
      config_file: config_file, 
      service_name: service_name
  }
end

def generate_config_file filenames
  r = template filenames[:config_file] do
    cookbook  new_resource.cookbook
    source    new_resource.source
    owner     new_resource.owner
    group     new_resource.group
    mode      new_resource.mode

    variables license_key:    new_resource.license_key,
              poll_interval:  new_resource.poll_interval,
              user:           new_resource.owner,
              pidfile:        filenames[:pidfile],
              logfile:        filenames[:logfile],
              service_config: new_resource.service_config
  end

  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

def generate_init_script filenames
  unless defaulted? :agent_name
    init_script_template = value_for_platform_family(
      rhel:   'plugin-agent-init-rhel.erb',
      debian: 'plugin-agent-init-deb.erb'
    )

    # deploy initscript
    i = template "/etc/init.d/#{filenames[:service_name]}" do
      mode      00755
      cookbook  'newrelic-ng'
      source    init_script_template
      variables config_file: filenames[:config_file],
                user:        new_resource.owner,
                group:       new_resource.group
    end

    new_resource.updated_by_last_action(true) if i.updated_by_last_action?
  end
end

def start_service filenames
  service filenames[:service_name] do
    supports   status: true, restart: true
    subscribes :restart, "template[#{filenames[:config_file]}]"
    action   [ :enable, :start ]
  end
end
