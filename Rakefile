require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'
require 'rake'
require 'jeweler'
require 'rake/testtask'
require 'rdoc/task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
Jeweler::Tasks.new do |gem|
  gem.name = "rabbit_replay"
  gem.homepage = "http://github.com/Bantik/rabbit_replay"
  gem.license = "MIT"
  gem.summary = %Q{Logging and replay for your Rabbit messages.}
  gem.description = %Q{Stores outbound Rabbit messages with all parameters needed for replay on failure.}
  gem.email = "corey@idolhands.com"
  gem.authors = ["Bantik"]
end

Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rabbit_replay #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
