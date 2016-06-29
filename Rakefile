#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

desc 'Run rubocop'
task :rubocop do
  sh 'rubocop --version'
  sh 'rubocop --display-cop-names'
end

desc 'Runs foodcritic linter'
task :foodcritic do
  if Gem::Version.new('1.9.2') <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), %w(tmp foodcritic cookbook))
    prepare_foodcritic_sandbox(sandbox)

    sh "foodcritic --epic-fail any #{File.dirname(sandbox)}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

task default: [:rubocop, :foodcritic]

private

def prepare_foodcritic_sandbox(sandbox)
  files = %w(*.md *.rb attributes definitions files libraries providers
             recipes resources templates)

  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
  puts "\n\n"
end
