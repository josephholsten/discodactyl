#!/usr/bin/env rake

require 'bundler'
Bundler.setup

require "rake/testtask"
Rake::TestTask.new do |test|
  test.test_files = Dir['test/**/test_*.rb']
  test.verbose = true
end
task :default => :test

require "rake/clean"
file 'MANIFEST.tmp' do
  sh %{find . -type f | sed 's/\\.\\///' | grep -v '.git' | sort > MANIFEST.tmp}
end
CLEAN << 'MANIFEST.tmp'

desc "Check the manifest against current files"
task :check_manifest => [:clean, 'MANIFEST', 'MANIFEST.tmp'] do
  puts `diff -du MANIFEST MANIFEST.tmp`
end

CLEAN << '.rake_tasks'

# vim: syntax=ruby
