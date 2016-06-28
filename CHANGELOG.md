# CHANGELOG for newrelic-ng

This file is used to list changes made in each version of newrelic-ng.

## 0.6.0:

- Use an apparently working key for testing
- Fix an issue with external `startup_mode`. See this [issue](https://github.com/chr4-cookbooks/newrelic-ng/issues/33)

## 0.5.4:

- Fix attribute types, sometimes String was used, even though Boolean or Integer types were valid
- Use `node['root_group']` attribute as default group attribute for php-agent daemon config file
- Use system wide ruby (install it if necessary) when installing newrelic generic agents
- Remove nginx plugin agent support, as it has been moved to packages: See
  [nr-plugin](http://nginx.com/nr-plugin/) website

## 0.5.3:

- Add "labels" option support for nrsysmond.cfg
- Add rubocop linting

## 0.5.2:

- Use `NR_INSTALL_SILENT` when installing php-agent

## 0.5.1:

- Add `hostname` attribute to nrsysmond
- Add `high_security` attribute to php-agent

## 0.5.0:

* Change binary name to newrelic-plugin-agent (was newrelic\_plugin\_agent)
* Upgrade newrelic-plugin-agent by default, in case an older version is installed

## 0.4.0:

* Add support for php-agent, thanks to Jeff Byrnes!

## 0.3.4:

* Add workaround for newrelic\_generic\_agent, was not starting up properly, due to bug in their status command

## 0.3.3:

* Install plugin-agent dependencies automatically
* KILL plugin-agent if TERM is not enough (after 10s)

## 0.3.2:

* Fix default recipe

## 0.3.1:

* Several small bugfixes

## 0.3.0:

* Adds support for generic newrelic agents (e.g. newrelic\_nginx\_agent, newrelic\_sidekiq\_agent)

## 0.2.0:

* Uses shared node['newrelic-ng']['license_key'] variable for all services
* Fix a problem with newrelic-plugin-agent service not starting up properly
* Migrate hashes to ruby-1.9 codestyle

## 0.1.0:

* Initial release of newrelic-ng
