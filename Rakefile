require 'bundler'
Bundler.require

# load some handy gem-related Rake tasks:
#  - build
#  - clean
#  - clobber
#  - install
#  - install:local
#  - release[remote]
require 'bundler/gem_tasks'

require 'webdrivers'

# load the webdrivers Rake tasks in namespace webdrivers
load 'webdrivers/Rakefile'

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:broken_rspec) do |_, task|
  task.default_path = 'spec'
  task.pattern = 'spec/**/*_spec.{rb,opal}'
end

task(:nil) {}

# create tasks:
# - selenium_chrome
# - selenium_edge
# - selenium_gecko
# - selenium_safari
%w[chrome edge gecko safari].each do |i|
  dependency = nil
  if %w[chrome edge gecko].include? i
    dependency = "webdrivers:#{i}driver:update"
  end
  desc "Run Selenium tests with #{i}"

  # each selenium_<browser> task depends on task webdrivers:<browser>driver:update,
  # except for browser safari. each of those tasks depend in turn on
  # taskwebdrivers:<browser>:version, which checks that a driver for the
  # browser version exists.
  task :"selenium_#{i}" => dependency do
    # start rackup, returning its pid without waiting for it to finish.
    server = Process.spawn("bundle", "exec", "rackup")

    # when ruby exits, stop and kill rackup immediately.
    at_exit { Process.kill(9, server) rescue nil }

    # wait 2 seconds then run the specs in spec/runner.rb.
    sleep 2
    ENV['BROWSER'] = i
    load 'spec/runner.rb'
  ensure
    # when ruby exits, stop and kill rackup immediately.
    Process.kill(9, server) rescue nil
  end
end

task :default => :selenium_chrome
