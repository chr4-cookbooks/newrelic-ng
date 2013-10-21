# newrelic-ng Cookbook

This cookbook provides LWRPs and recipes to install and configure different monitoring services for Newrelic.

* Official Newrelic nrsysmond
* MeetMe [newrelic-plugin-agent](https://github.com/MeetMe/newrelic-plugin-agent)
* Generic ruby newrelic agents like
  * [newrelic_sidekiq_agent](https://github.com/eksoverzero/newrelic_sidekiq_agent)
  * [newrelic_nginx_agent](https://rpm.newrelic.com/accounts/29043/plugins/directory/13)
  * Should work with all ruby newrelic agents that are using config/newrelic_plugin.yml configuration file and newrelic_[NAME]_agent.daemon

This cookbook requires Chef 11 or later.

## Attributes

### server monitoring with nrsysmond

You can set your Newrelic license_key in the following attribute

```ruby
node['newrelic-ng']['license_key'] = 'CHANGE_ME'
```

The 'config' attribute actually supports all other configuration options that nrsysmond accepts.
You can e.g. disable ssl

```ruby
node['newrelic-ng']['nrsysmond']['config']['ssl'] = false
```

For a complete list of attributes, please see [here](https://github.com/flinc-chef/newrelic-ng/blob/master/attributes/nrsysmond.rb)


### plugin-agent

You can set your Newrelic license key (note: this one is usually different than the one for server monitoring), as well as other options in the following attribute (default values shown below)

```ruby
node['newrelic-ng']['license_key'] = 'CHANGE_ME'
node['newrelic-ng']['plugin-agent']['poll_interval'] = 60
node['newrelic-ng']['plugin-agent']['pidfile'] = '/var/run/newrelic/newrelic_plugin_agent.pid'
node['newrelic-ng']['plugin-agent']['logfile'] = '/var/log/newrelic/newrelic_plugin_agent.log'
```

Set the pip package to install. Defaults to 'newrelic-plugin-agent'. You can set it e.g. to your github fork

```ruby
node.default['newrelic']['plugin-agent']['pip_package'] = 'git+git://github.com/chr4/newrelic-plugin-agent.git@fix-postgres-9.2'
```

For configuring your services, you need to insert a YAML string into the service_config attribute

```ruby
node['newrelic-ng']['plugin-agent']['service_config'] = <<-EOS
postgresql:
  host: localhost
  port: 5432
  user: postgres
  dbname: postgres
EOS
```

### generic-agent

Installs a generic plugin agent. E.g.

[newrelic_nginx_agent](https://rpm.newrelic.com/accounts/29043/plugins/directory/13):

```ruby
node['newrelic-ng']['generic-agent']['agents']['nginx_status_agent'] = {
    source: 'http://nginx.com/download/newrelic/newrelic_nginx_agent.tar.gz',
    config: <<-EOS
- instance_name: localhost
  status_url: http://localhost/nginx_stub_status
EOS
  }
}
```

[newrelic_sidekiq_agent](https://github.com/eksoverzero/newrelic_sidekiq_agent):

```ruby
default['newrelic-ng']['generic-agent']['agents']['sidekiq_status_agent'] = {
    source: 'https://github.com/eksoverzero/newrelic_sidekiq_agent/archive/V2.0.tar.gz',
    config: <<-EOS
- instance_name: "App name"
  uri: "redis://localhost:6379"
  namespace: "namespace"
EOS
  }
}
```

## Recipes

To use the recipes, add the following to your metadata.rb

    depends 'newrelic-ng'

### default

* Includes newrelic-ng::nrsysmond-default

### nrsysmond-default

* Includes newrelic-ng::nrsysmond-install
* Configures and starts nrsysmond according to the attributes

### nrsysmond-install

* Includes newrelic-ng::newrelic-repository
* Installs newrelic-sysmond package

### plugin-agent-default

* Includes newrelic-ng::plugin-agent-install
* Configures and starts newrelic-plugin-agent according to the attributes

### plugin-agent-install

* Install python, python-pip and python-psycopg2
* Install newrelic-plugin-agent using pip
* Install newrelic-plugin-agent initscript (Debian, Ubuntu only)
* Create run/log directories

### generic-agent-default

* Installs a generic newrelic agent.

### newrelic-repository

* Sets up the Newrelic apt/yum repository


## Providers

To use the providers, add the following to your metadata.rb

```ruby
depends 'newrelic-ng'
```

### newrelic_ng_nrsysmond

When nrsysmond is installed (e.g. using the newrelic-ng::nrsysmond-install recipe), you can configure it using the LWRP.

```ruby
newrelic_ng_nrsysmond 'YOUR_LICENSE_KEY'
```

For more sophisticated setups, you can specify the follwoing additional attributes (they default to the node attributes)

```ruby
newrelic_ng_nrsysmond 'custom' do
  license_key 'MY_PRODUCTION_KEY' if node.chef_environment == 'production'
  license_key 'MY_STAGING_KEY'    if node.chef_environment == 'staging'

  # additional nrsysmond configuration options
  ssl            false
  loglevel       'info'
  proxy          nil
  ssl_ca_bundle  nil
  ssl_ca_path    '/myca/path'
  pidfile        '/tmp/nrsysmond.pid'
  collector_host 'my-collector-host.com'
  timeout        10

  # path and attributes of nrsysmond.cfg
  owner       'root'
  group       'root'
  mode        00600
  config_file '/etc/nrsysmond.cfg'

  # you can also specify your own configuration template
  cookbook    'yourcookbook'
  source      'yoursourcefile'
end
```

### newrelic_ng_plugin_agent

When the plugin-agent is installed (e.g. using the newrelic-ng::plugin-agent-install recipe), you can configure it using the LWRP.

```ruby
newrelic_ng_plugin_agent 'YOUR_LICENSE_KEY'
```

For more sophisticated setups, you can specify the follwoing additional attributes (they default to the node attributes)

```ruby
newrelic_ng_plugin_agent 'custom' do
  license_key 'MY_PRODUCTION_KEY' if node.chef_environment == 'production'
  license_key 'MY_STAGING_KEY'    if node.chef_environment == 'staging'

  # additional plugin-agent configuration options
  poll_interval  20
  logfile        '/tmp/plugin-agent.log'
  pidfile        '/tmp/plugin-agent.pid'

  # set your service configuration
  service_config <<-EOS
postgresql:
  host: localhost
  port: 5432
  user: postgres
  dbname: postgres
EOS

  # path and attributes of nrsysmond
  owner       'root'
  group       'root'
  mode        00600
  config_file '/etc/plugin-agent.cfg'

  # you can also specify your own configuration template
  cookbook    'yourcookbook'
  source      'yoursourcefile'
end
```

### newrelic_ng_generic_agent

You can install and configure generic ruby newrelic agents also via this LWRPs. For more information, see attributes and recipes section above.

Example:

```ruby
newrelic_ng_generic_agent 'MY_LICENSE_KEY' do
  plugin_name 'nginx_status_agent'
  source 'http://nginx.com/download/newrelic/newrelic_nginx_agent.tar.gz'
  config <<-EOS
- instance_name: localhost
  status_url: http://localhost/nginx_stub_status
EOS
end
```

```ruby
newrelic_ng_generic_agent 'MY_LICENSE_KEY' do
  plugin_name 'sidekiq_status_agent'
  source 'https://github.com/eksoverzero/newrelic_sidekiq_agent/archive/V2.0.tar.gz'
  config <<-EOS
- instance_name: "App name"
  uri: "redis://localhost:6379"
  namespace: "namespace"
EOS
end
```

You can specify the following additional attributes

```ruby
target_dir '/opt/newrelic-agents'
owner      'newrelic'
group      'newrelic'
```

The following actions are supported

```ruby
action :install_and_configure # default
action :install               # only install the agent
action :configure             # only configure the agent
```


# Contributing

e.g.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

# License and Authors

Author: Chris Aumann <me@chr4.org>
Contributors: Cameron Johnston <cameron@needle.com>, Jeff Byrnes <jeff@evertrue.com>

License: GPLv3
