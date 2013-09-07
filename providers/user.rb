#
# Cookbook Name:: newrelic-ng
# Provider:: user
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

action :create do
  r = group new_resource.group do
    system new_resource.system
  end
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  # we need a shell, because we are using 'su' later to start the daemon
  r = user new_resource.name do
    gid    new_resource.group
    shell  new_resource.shell
    system new_resource.system
  end
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

action :delete do
  r = group(new_resource.group) { action :delete }
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  r = user(new_resource.name) { action :delete }
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
