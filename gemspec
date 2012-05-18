# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name    = "shoutcast_status"
  s.version = "0.1.1"

  s.authors       = ["Paul Battley"]
  s.email         = "pbattley@gmail.com"
  s.files         = Dir["{lib,test}/**/*"]
  s.homepage      = "http://github.com/threedaymonk/shoutcast_status"
  s.require_paths = ["lib"]
  s.summary       = "Get station info from a Shoutcast server"

  s.add_dependency "therubyracer"
  s.add_development_dependency "mocha"
end
