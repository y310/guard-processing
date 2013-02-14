# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/processing/version'

Gem::Specification.new do |gem|
  gem.name          = "guard-processing"
  gem.version       = Guard::ProcessingVersion::VERSION
  gem.authors       = ["Yusuke Mito"]
  gem.email         = ["y310.1984@gmail.com"]
  gem.description   = %q{Guard plugin for Processing}
  gem.summary       = %q{Guard plugin for Processing}
  gem.homepage      = "http://github.com/y310/guard-processing"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
