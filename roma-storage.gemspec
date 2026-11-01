
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roma/storage/version"

Gem::Specification.new do |spec|
  spec.name          = "roma-storage"
  spec.version       = Roma::Storage::VERSION
  spec.authors       = ["Tatsuya Sato"]
  spec.email         = ["satoryu.1981@gmail.com"]

  spec.summary       = %q{The storages of ROMA.}
  spec.description   = %q{The base class of the storages of ROMA, and the storage on a Ruby Hash.}
  spec.homepage      = "https://github.com/roma/roma-storage"
  spec.license       = "GPL-3.0-only"
  spec.required_ruby_version = '>= 3.4'

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|bin)/|^\.})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "test-unit"
end
