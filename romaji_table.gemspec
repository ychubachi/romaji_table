# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'romaji_table/version'

Gem::Specification.new do |spec|
  spec.name          = "romaji_table"
  spec.version       = RomajiTable::VERSION
  spec.authors       = ["Yoshihide Chubachi"]
  spec.email         = ["yoshi@chubachi.net"]
  spec.description   = %q{Romaji Table Generator}
  spec.summary       = %q{A DSL for defining rules to generate a romaji transfer mapping table which can be used by Japanese FEP like Google IME.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'yard-rspec'
  spec.add_development_dependency 'ice_nine'
  spec.add_development_dependency 'aruba'

end
