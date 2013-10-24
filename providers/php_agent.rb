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

  service "newrelic-daemon" do
    supports status: true, start: true, stop: true, restart: true
  end

  # https://newrelic.com/docs/php/newrelic-daemon-startup-modes
  Chef::Log.info("newrelic-daemon startup mode: #{new_resource.startup_mode}")

  case new_resource.startup_mode
    when "agent"
      # agent startup mode

      # ensure that the daemon isn't currently running
      service "newrelic-daemon" do
        # stops the service if it's running and disables it from
        # starting at system boot time
        action [:disable, :stop]
      end

      # ensure that the file #{new_resource.daemon_config_file} does
      # not exist if it does, move it aside (or remove it)
      execute "newrelic-backup-cfg" do
        command "mv #{new_resource.daemon_config_file} #{new_resource.daemon_config_file}.external"
        only_if do ::File.exists?(new_resource.daemon_config_file) end
      end

      # ensure that the file #{new_resource.daemon_upgrade_file}
      # does not exist if it does, move it aside (or remove it)
      execute "newrelic-backup-key" do
        command "mv #{new_resource.daemon_upgrade_file} #{new_resource.daemon_upgrade_file}.external"
        only_if do ::File.exists?(new_resource.daemon_upgrade_file) end
      end

      # configure New Relic INI file and set the daemon related options
      # (documented at /usr/lib/newrelic-php5/scripts/newrelic.ini.template)
      # and restart the web server in order to pick up the new settings
      r = template new_resource.config_file do
        cookbook  new_resource.cookbook
        source    new_resource.source
        owner     new_resource.owner
        group     new_resource.group
        mode      new_resource.mode

        variables license_key:                              new_resource.license_key,
                  enabled:                                  new_resource.enabled,
                  logfile:                                  new_resource.logfile,
                  loglevel:                                 new_resource.loglevel,
                  appname:                                  new_resource.appname,
                  daemon_logfile:                           new_resource.daemon_logfile,
                  daemon_loglevel:                          new_resource.daemon_loglevel,
                  daemon_port:                              new_resource.daemon_port,
                  daemon_max_threads:                       new_resource.daemon_max_threads,
                  daemon_ssl:                               new_resource.daemon_ssl,
                  daemon_proxy:                             new_resource.daemon_proxy,
                  daemon_pidfile:                           new_resource.daemon_pidfile,
                  daemon_location:                          new_resource.daemon_location,
                  daemon_collector_host:                    new_resource.daemon_collector_host,
                  daemon_dont_launch:                       new_resource.daemon_dont_launch,
                  capture_params:                           new_resource.capture_params,
                  ignored_params:                           new_resource.ignored_params,
                  error_collector_enabled:                  new_resource.error_collector_enabled,
                  error_collector_record_database_errors:   new_resource.error_collector_record_database_errors,
                  error_collector_prioritize_api_errors:    new_resource.error_collector_prioritize_api_errors,
                  browser_monitoring_auto_instrument:       new_resource.browser_monitoring_auto_instrument,
                  transaction_tracer_enabled:               new_resource.transaction_tracer_enabled,
                  transaction_tracer_threshold:             new_resource.transaction_tracer_threshold,
                  transaction_tracer_detail:                new_resource.transaction_tracer_detail,
                  transaction_tracer_slow_sql:              new_resource.transaction_tracer_slow_sql,
                  transaction_tracer_stack_trace_threshold: new_resource.transaction_tracer_stack_trace_threshold,
                  transaction_tracer_explain_enabled:       new_resource.transaction_tracer_explain_enabled,
                  transaction_tracer_explain_threshold:     new_resource.transaction_tracer_explain_threshold,
                  transaction_tracer_record_sql:            new_resource.transaction_tracer_record_sql,
                  transaction_tracer_custom:                new_resource.transaction_tracer_custom,
                  framework:                                new_resource.framework,
                  webtransaction_name_remove_trailing_path: new_resource.webtransaction_name_remove_trailing_path,
                  webtransaction_name_functions:            new_resource.webtransaction_name_functions,
                  webtransaction_name_files:                new_resource.webtransaction_name_files,
                  daemon_auditlog:                          new_resource.daemon_auditlog,
                  analytics_events_enabled:                 new_resource.analytics_events_enabled

        notifies :restart, "service[#{new_resource.server_service_name}]", :delayed
      end

      new_resource.updated_by_last_action(true) if r.updated_by_last_action?

    when "external"
      # external startup mode

      # configure proxy daemon settings
      r = template new_resource.daemon_config_file do
        cookbook  new_resource.cookbook
        source    new_resource.source
        owner     new_resource.owner
        group     new_resource.group
        mode      new_resource.mode

        variables daemon_pidfile:        new_resource.daemon_pidfile,
                  daemon_logfile:        new_resource.daemon_logfile,
                  daemon_loglevel:       new_resource.daemon_loglevel,
                  daemon_port:           new_resource.daemon_port,
                  daemon_ssl:            new_resource.daemon_ssl,
                  daemon_max_threads:    new_resource.daemon_max_threads,
                  daemon_collector_host: new_resource.daemon_collector_host,
                  daemon_auditlog:       new_resource.daemon_auditlog

        notifies :restart, "service[newrelic-daemon]", :immediately
        notifies :restart, "service[#{new_resource.server_service_name}]", :delayed
      end

      new_resource.updated_by_last_action(true) if r.updated_by_last_action?

      service "newrelic-daemon" do
        # start the service if it's not running and enable it to start at system boot time
        action   [ :enable, :start ]
      end
    else
      Chef::Application.fatal!("#{new_resource.startup_mode} is not a valid newrelic-daemon startup mode.")
  end
end
