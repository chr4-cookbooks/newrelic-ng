name             'newrelic-ng'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GNU Public License 3.0'
description      'Installs/Configures newrelic monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'
depends          'apt'
depends          'python'

%w{ ubuntu debian redhat centos fedora amazon suse scientific }.each do |os|
  supports os
end
