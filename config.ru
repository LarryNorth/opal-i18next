require "bundler"
Bundler.require

sprockets_env = Opal::RSpec::SprocketsEnvironment.new(
  spec_pattern         = "spec/**/*_spec.{rb,opal}",
  spec_exclude_pattern = nil,
  spec_files           = nil,
  default_path         = "spec"
)

run Opal::Sprockets::Server.new(sprockets: sprockets_env) { |s|
  s.main = "opal/rspec/sprockets_runner"
  s.append_path "spec"
  s.index_path = "index.html.erb"
  s.debug = true
}
