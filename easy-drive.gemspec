lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "easy-drive"
  spec.version       = "0.0.3"
  spec.authors       = ["Shinohara Teruki"]
  spec.email         = ["ts_3156@yahoo.co.jp"]
  spec.description   = %q{I just want to copy files on google drive.}
  spec.summary       = %q{I just want to copy files on google drive.}
  spec.license       = "Apache 2.0"
  spec.homepage      = "https://github.com/ts-3156/easy-drive"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_runtime_dependency "google-api-client", '= 0.7.1'
end
