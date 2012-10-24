Gem::Specification.new do |s|
  s.name        = "sinatra-url"
  s.version     = "0.0.2"
  s.description = "Simple sinatra extension that gives you the ability to use named URLs in your code"
  s.summary     = "Named URLs for Sinatra apps"
  s.authors     = ["Nicolas Sanguinetti"]
  s.email       = "hi@nicolassanguinetti.info"
  s.homepage    = "http://github.com/foca/sinatra-url"
  s.has_rdoc    = false
  s.files       = `git ls-files`.split "\n"
  s.platform    = Gem::Platform::RUBY

  s.add_dependency("sinatra")
end
