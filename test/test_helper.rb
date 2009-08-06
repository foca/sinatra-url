require "test/unit"
require "contest"
require "rack/test"
require File.expand_path(File.dirname(__FILE__) + "/../lib/sinatra/url")

begin
  require "redgreen"
rescue LoadError
end

if ENV["DEBUG"]
  require "ruby-debug"
else
  def debugger
    puts "Run your tests with DEBUG=1 to use the debugger"
  end
end

class Sinatra::TestApp < Sinatra::Base
  include Test::Unit::Assertions
  register Sinatra::URL
end

Sinatra::Base.set :environment, :test

class Test::Unit::TestCase
  include Rack::Test::Methods

  attr_reader :app

  def mock_app(base=Sinatra::TestApp, &block)
    @app = Sinatra.new(base, &block)
  end
end
