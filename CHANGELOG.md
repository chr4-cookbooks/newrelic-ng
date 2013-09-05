# CHANGELOG for newrelic-ng

This file is used to list changes made in each version of newrelic-ng.

## 0.3.0:

* Adds support for generic newrelic agents (e.g. newrelic_nginx_agent, newrelic_sidekiq_agent)

## 0.2.0:

* Uses shared node['newrelic-ng']['license_key'] variable for all services
* Fix a problem with newrelic-plugin-agent service not starting up properly
* Migrate hashes to ruby-1.9 codestyle

## 0.1.0:

* Initial release of newrelic-ng
