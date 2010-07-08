lib     = File.expand_path("../lib/discodactyl.rb", __FILE__)
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

Gem::Specification.new do |spec|
  spec.name = "discodactyl"
  spec.author = "Joseph Anthony Pasquale Holsten"
  spec.email = "joseph@josephholsten.com"
  spec.homepage = "http://dactylo.us"
  spec.description = %q{Discodactyl is an experimental toolkit for XRD service discovery documents and related protocols. It includes implementations of XRD URITemplate Link-Patterns, basic site-meta support, HTTP Link header parsing, acct: URIs and a webfinger poking stick.}
  spec.extra_rdoc_files = %w[ AUTHORS CHANGELOG COPYING INSTALL NEWS README TODO ]
  spec.rdoc_options << "--charset=UTF-8" <<
                       "--title" << "Discodactyl Documentation" <<
                       "--main"  << "README"
  spec.version = version
  spec.summary = spec.description.split(/\.\s+/).first
  spec.files = File.read("MANIFEST").split(/\r?\n\r?/)
  spec.executables = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(/^test\/.*test_.*\.rb$/)
  spec.add_runtime_dependency 'nokogiri', '~>1.4.0'
  spec.add_runtime_dependency 'actionpack', '~>2.3.0'
  spec.add_runtime_dependency 'feedzirra', '~>0.0.23'
  spec.add_runtime_dependency 'mofo', '~>0.2.0'
end
