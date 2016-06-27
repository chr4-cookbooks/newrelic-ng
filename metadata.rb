# This was only made zendesk for progressing until community PR will get accepted:
# https://github.com/chr4-cookbooks/newrelic-ng/issues/33
name             'zendesk_newrelic-ng'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GNU Public License 3.0'
description      'Installs/Configures newrelic monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.5'
depends          'apt'
depends          'build-essential'
depends          'python'
depends          'php'

%w(ubuntu debian redhat centos amazon suse scientific).each do |os|
  supports os
end
