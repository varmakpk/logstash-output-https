Gem::Specification.new do |s|
  s.name = 'logstash-output-https'
  s.version         = "0.1.0"
  s.licenses = ["Apache License (2.0)"]
  s.summary = "This https plugin sends the output to https server."
  s.description = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install <path to gemname>."
  s.authors = ["EiQ"]
  s.email = "kpkvarma@gmail.com"
  s.homepage = "https://github.com/varmakpk/logstash-output-https"
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", ">= 1.4.0", "< 2.0.0"
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_development_dependency "logstash-devutils"
end
