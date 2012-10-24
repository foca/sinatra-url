require "rake/testtask"

begin
  require "hanna/rdoctask"
rescue LoadError
  require 'rdoc/task'
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.title = "API Documentation for Sinatra::Urls"
  rd.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
  rd.rdoc_dir = "doc"
end

begin
  require "mg"
  MG.new("sinatra-urls.gemspec")

  task :build => :vendor
rescue LoadError
end

desc "Default: run tests"
task :default => :test

Rake::TestTask.new
