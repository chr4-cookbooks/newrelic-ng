#
# Cookbook Name:: newrelic-ng
# Resource:: php_agent
#
# Copyright 2013, Jeff Byrnes <jeff@evertrue.com>
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

actions        :configure
default_action :configure

attribute :owner,          kind_of: String, default: 'root'
attribute :group,          kind_of: String, default: node['root_group']
attribute :shell,          kind_of: String, default: node['newrelic-ng']['user']['shell']
attribute :system,         kind_of: [TrueClass, FalseClass], default: node['newrelic-ng']['user']['system']

attribute :mode,           kind_of: [Integer, String], default: 0o644

attribute :cookbook,       kind_of: String, default: 'newrelic-ng'
attribute :source,         kind_of: String, default: 'newrelic.ini.php.erb'
attribute :source_cfg,     kind_of: String, default: 'newrelic.cfg.erb'

attribute :license_key,    kind_of: String, name_attribute: true

attribute :config_file,            kind_of: String, default: node['newrelic-ng']['app_monitoring']['php-agent']['config_file']
attribute :startup_mode,           kind_of: String, default: node['newrelic-ng']['app_monitoring']['php-agent']['startup_mode']
attribute :server_service_name,    kind_of: String, default: node['newrelic-ng']['app_monitoring']['php-agent']['server_service_name']

# Paths to files used only in configuring PHP Agent, not in actual config files
attribute :daemon_config_file,     kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['config_file']
attribute :daemon_upgrade_file,    kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['upgrade_file']

# Settings to pass in to newrelic.cfg and/or newrelic.ini
attribute :enabled,                                  kind_of: String, default: node['newrelic-ng']['app_monitoring']['enabled']
attribute :logfile,                                  kind_of: String, default: node['newrelic-ng']['app_monitoring']['logfile']
attribute :loglevel,                                 kind_of: String, default: node['newrelic-ng']['app_monitoring']['loglevel']
attribute :appname,                                  kind_of: String, default: node['newrelic-ng']['app_monitoring']['appname']
attribute :daemon_pidfile,                           kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['pidfile']
attribute :daemon_logfile,                           kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['logfile']
attribute :daemon_loglevel,                          kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['loglevel']
attribute :daemon_port,                              kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['port']
attribute :daemon_max_threads,                       kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['max_threads']
attribute :daemon_ssl,                               kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['ssl']
attribute :daemon_proxy,                             kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['proxy']
attribute :daemon_location,                          kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['location']
attribute :daemon_collector_host,                    kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['collector_host']
attribute :daemon_dont_launch,                       kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['dont_launch']
attribute :daemon_auditlog,                          kind_of: String, default: node['newrelic-ng']['app_monitoring']['daemon']['auditlog']
attribute :capture_params,                           kind_of: String, default: node['newrelic-ng']['app_monitoring']['capture_params']
attribute :ignored_params,                           kind_of: String, default: node['newrelic-ng']['app_monitoring']['ignored_params']
attribute :error_collector_enabled,                  kind_of: String, default: node['newrelic-ng']['app_monitoring']['error_collector']['enabled']
attribute :error_collector_record_database_errors,   kind_of: String, default: node['newrelic-ng']['app_monitoring']['error_collector']['record_database_errors']
attribute :error_collector_prioritize_api_errors,    kind_of: String, default: node['newrelic-ng']['app_monitoring']['error_collector']['prioritize_api_errors']
attribute :browser_monitoring_auto_instrument,       kind_of: String, default: node['newrelic-ng']['app_monitoring']['browser_monitoring']['auto_instrument']
attribute :transaction_tracer_enabled,               kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['enabled']
attribute :transaction_tracer_threshold,             kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['threshold']
attribute :transaction_tracer_detail,                kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['detail']
attribute :transaction_tracer_slow_sql,              kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['slow_sql']
attribute :transaction_tracer_stack_trace_threshold, kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['stack_trace_threshold']
attribute :transaction_tracer_explain_enabled,       kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['explain_enabled']
attribute :transaction_tracer_explain_threshold,     kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['explain_threshold']
attribute :transaction_tracer_record_sql,            kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['record_sql']
attribute :transaction_tracer_custom,                kind_of: String, default: node['newrelic-ng']['app_monitoring']['transaction_tracer']['custom']
attribute :framework,                                kind_of: String, default: node['newrelic-ng']['app_monitoring']['framework']
attribute :webtransaction_name_remove_trailing_path, kind_of: String, default: node['newrelic-ng']['app_monitoring']['webtransaction']['name']['remove_trailing_path']
attribute :webtransaction_name_functions,            kind_of: String, default: node['newrelic-ng']['app_monitoring']['webtransaction']['name']['functions']
attribute :webtransaction_name_files,                kind_of: String, default: node['newrelic-ng']['app_monitoring']['webtransaction']['name']['files']
attribute :analytics_events_enabled,                 kind_of: String, default: node['newrelic-ng']['app_monitoring']['analytics']['events']['enabled']
attribute :high_security,                            kind_of: String, default: node['newrelic-ng']['app_monitoring']['high_security']
