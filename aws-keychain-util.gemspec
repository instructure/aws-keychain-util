# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "aws-keychain-util"
  gem.version       = '0.0.12'
  gem.authors       = ["Zach Wily"]
  gem.email         = ["zach@zwily.com"]
  gem.description   = %q{Helps manage a keychain of AWS credentials on OS X.}
  gem.summary       = %q{Helps manage a keychain of AWS credentials on OS X.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('ruby-keychain', '~> 0.2.0')
  gem.add_dependency('highline')
  gem.add_dependency('aws-sdk')
end
