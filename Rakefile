# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bio-bgzf"
  gem.homepage = "http://github.com/csw/bioruby-bgzf"
  gem.license = "MIT"
  gem.summary = %Q{Reading/writing BGZF blocks}
  gem.description = %Q{This library provides support for BGZF (Blocked GZip Format) in Ruby. BGZF, originally defined as part of the SAM/BAM specification, is used to compress record-oriented data in a way that facilitates random access, unlike plain gzip. BGZF is principally used for bioinformatics data but would be useful in other contexts as well.}
  gem.email = "cswh@umich.edu"
  gem.authors = ["Artem Tarasov", "Clayton Wheeler"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :test => :spec

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-bgzf #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
