lib     = File.expand_path("../lib/discodactyl.rb", __FILE__)
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

Gem::Specification.new do |spec|
  spec.name = "discodactyl"
  spec.author = "Joseph Anthony Pasquale Holsten"
  spec.email = "joseph@josephholsten.com"
  spec.homepage = "http://dactylo.us"
  spec.description = %q{Discodactyl is an experimental toolkit for XRD service discovery documents and related protocols. It includes implementations of XRD URITemplate Link-Patterns, basic site-meta support, HTTP Link header parsing, acct: URIs and a webfinger poking stick.}
  spec.extra_rdoc_files = %w[ AUTHORS CHANGELOG COPYING INSTALL NEWS README.rdoc TODO ]
  spec.rdoc_options << "--charset=UTF-8" <<
                       "--title" << "Discodactyl Documentation" <<
                       "--main"  << "README.rdoc"
  spec.version = version
  spec.summary = spec.description.split(/\.\s+/).first
  spec.files = File.read("MANIFEST").split(/\r?\n\r?/)
  spec.executables = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(/^test\/.*test_.*\.rb$/)
  spec.add_runtime_dependency 'nokogiri', '>= 1.4.2'
  spec.add_runtime_dependency 'actionpack', '>= 3.0.8'
  spec.add_runtime_dependency 'feedzirra', '>= 0.0.22', '< 0.0.31'
  spec.add_runtime_dependency 'prism', '>= 0.1.0'
  spec.add_development_dependency 'mocha', '>= 0.12.7'
  spec.add_development_dependency 'rake', '>= 0.9.2.2'
end
