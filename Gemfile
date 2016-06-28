source 'https://rubygems.org'

gem 'berkshelf'

group :integration do
  gem 'test-kitchen'
end

group :vagrant do
  gem 'vagrant-wrapper'
  gem 'kitchen-vagrant'
end

group :development, :test do
  gem 'rake'
  gem 'rubocop'
  gem 'foodcritic'
end

group :docker do
  gem 'kitchen-docker', '~> 2.1.0'
end
