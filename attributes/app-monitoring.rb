#
# Cookbook Name:: newrelic-ng
# Attributes:: app-monitoring
#
# Copyright 2012-2013, Escape Studios
#

default['newrelic-ng']['app_monitoring']['php-agent']['config_file'] = "#{node['php']['ext_conf_dir']}/newrelic.ini"
default['newrelic-ng']['app_monitoring']['php-agent']['startup_mode'] = 'agent'
default['newrelic-ng']['app_monitoring']['php-agent']['server_service_name'] = 'apache2'

default['newrelic-ng']['app_monitoring']['enabled'] = nil
default['newrelic-ng']['app_monitoring']['logfile'] = nil
default['newrelic-ng']['app_monitoring']['loglevel'] = nil
default['newrelic-ng']['app_monitoring']['appname'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['config_file'] = '/etc/newrelic/newrelic.cfg'
default['newrelic-ng']['app_monitoring']['daemon']['upgrade_file'] = '/etc/newrelic/upgrade_please.key'
default['newrelic-ng']['app_monitoring']['daemon']['logfile'] = '/var/log/newrelic/newrelic-daemon.log'
default['newrelic-ng']['app_monitoring']['daemon']['loglevel'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['port'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['max_threads'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['ssl'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['proxy'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['pidfile'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['location'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['collector_host'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['dont_launch'] = nil
default['newrelic-ng']['app_monitoring']['capture_params'] = nil
default['newrelic-ng']['app_monitoring']['ignored_params'] = nil
default['newrelic-ng']['app_monitoring']['error_collector']['enabled'] = nil
default['newrelic-ng']['app_monitoring']['error_collector']['record_database_errors'] = nil
default['newrelic-ng']['app_monitoring']['error_collector']['prioritize_api_errors'] = nil
default['newrelic-ng']['app_monitoring']['browser_monitoring']['auto_instrument'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['enabled'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['threshold'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['detail'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['slow_sql'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['stack_trace_threshold'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['explain_enabled'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['explain_threshold'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['record_sql'] = nil
default['newrelic-ng']['app_monitoring']['transaction_tracer']['custom'] = nil
default['newrelic-ng']['app_monitoring']['framework'] = nil
default['newrelic-ng']['app_monitoring']['webtransaction']['name']['remove_trailing_path'] = nil
default['newrelic-ng']['app_monitoring']['webtransaction']['name']['functions'] = nil
default['newrelic-ng']['app_monitoring']['webtransaction']['name']['files'] = nil
default['newrelic-ng']['app_monitoring']['daemon']['auditlog'] = nil
default['newrelic-ng']['app_monitoring']['analytics']['events']['enabled'] = nil
default['newrelic-ng']['app_monitoring']['high_security'] = nil
