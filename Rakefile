#!/usr/bin/env rake
require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rake/clean"


dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "discodactyl.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

spec = Gem::Specification.new do |spec|
  spec.name             = "discodactyl"
  spec.author           = "Joseph Anthony Pasquale Holsten"
  spec.email            = "joseph@josephholsten.com"
  spec.homepage         = "http://dactylo.us"
  spec.extra_rdoc_files = %w[ COPYING README INSTALL ChangeLog History ]
  spec.rdoc_options     << "--title" << "Discodactyl Documentation" <<
                           "--main"  << "README"
  spec.rubyforge_project = 'discodactyl'
  spec.require_path     = "lib"
  spec.description      = <<END_DESC
Discodactyl is an experimental toolkit for XRD service discovery documents and related protocols. It includes implementations of XRD URITemplate Link-Patterns, basic site-meta support, HTTP Link header parsing, acct: URIs and a webfinger poking stick.
END_DESC
  spec.version          = version
  spec.summary          = spec.description.split(/\.\s+/).first
  spec.platform         = Gem::Platform::RUBY
  spec.test_files       = Dir['test/**/test_*.rb']
  spec.files            = File.read("MANIFEST").split(/\r?\n\r?/)
  spec.executables      = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.has_rdoc         = true
end

Rake::TestTask.new do |test|
  test.libs       << "test"
  test.test_files = spec.test_files
  test.verbose    =  true
end
task :default => :test

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

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
