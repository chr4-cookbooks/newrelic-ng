#
# Cookbook Name:: newrelic-ng
# Provider:: generic_agent
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

def install_agent
  # Do install system-wide ruby and use this ruby for the agent
  node['newrelic-ng']['generic-agent']['ruby-packages'].each do |pkg|
    package pkg
  end

  # We need to make sure we have a unique name.
  # bundler might be installed already in e.g. the chruby/rvm environment
  gem_package "bundler (#{new_resource.plugin_name})" do
    package_name 'bundler'
    gem_binary '/usr/bin/gem'
  end

  package 'gzip'  if new_resource.source  =~ /\.(tgz|gz)$/
  package 'bzip2' if new_resource.source  =~ /\.bz2$/

  newrelic_ng_user 'default' do
    name   new_resource.owner
    group  new_resource.group
    shell  new_resource.shell
    system new_resource.system
  end

  target = "#{new_resource.target_dir}/#{new_resource.plugin_name}"

  directory target do
    mode      0o755
    recursive true
  end

  daemon = "#{new_resource.target_dir}/#{new_resource.plugin_name}/newrelic_#{new_resource.plugin_name.split('_').first}_agent.daemon"

  remote_file "#{Chef::Config[:file_cache_path]}/#{::File.basename(new_resource.source)}" do
    source   new_resource.source
    action   :create_if_missing
  end

  execute "extract_#{new_resource.plugin_name}" do
    command "tar --strip-components=1 -xvzf #{::File.basename(new_resource.source)} -C #{target}" if new_resource.source  =~ /\.(tgz|gz)$/
    command "tar --strip-components=1 -xvjf #{::File.basename(new_resource.source)} -C #{target}" if new_resource.source  =~ /\.bz2$/

    cwd     Chef::Config[:file_cache_path]
    not_if { ::File.exist?(daemon) }
  end

  execute "bundle_install_#{new_resource.plugin_name}" do
    command 'bundle install'
    cwd     target
  end

  execute "chown_#{new_resource.plugin_name}" do
    command "chown -R #{new_resource.owner}:#{new_resource.group} #{target}"
  end
end

def configure_agent
  config_file = "#{new_resource.target_dir}/#{new_resource.plugin_name}/config/newrelic_plugin.yml"

  r = template config_file do
    owner     new_resource.owner
    group     new_resource.group
    mode      0o644
    source    'generic-agent.yml.erb'
    cookbook  'newrelic-ng'
    variables license_key: new_resource.license_key,
              plugin_name: new_resource.plugin_name,
              config:      new_resource.config
  end
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  daemon = "#{new_resource.target_dir}/#{new_resource.plugin_name}/newrelic_#{new_resource.plugin_name.split('_').first}_agent.daemon"

  service "newrelic_plugin_#{new_resource.plugin_name}" do
    provider        Chef::Provider::Service::Simple
    supports        status: true
    start_command   "su #{new_resource.owner} -c '#{daemon} start'"
    stop_command    "su #{new_resource.owner} -c '#{daemon} stop'"
    restart_command "su #{new_resource.owner} -c '#{daemon} restart'"

    # status always returns 0, so we're grepping for pid as a workaround
    status_command  "su #{new_resource.owner} -c '#{daemon} status |grep -q pid'"

    subscribes      :restart, "template[#{config_file}]"
    action          :start
  end
end

action :install_and_configure do
  install_agent
  configure_agent
end

action :install do
  install_client
end

action :configure do
  configure_agent
end
