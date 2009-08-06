require "sinatra/base"

module Sinatra
  module URL
    def self.extended(app)
      app.module_eval do
        extend DSL
        include Helpers
      end
    end

    class Mapper
      def initialize
        @map = {}
      end

      def [](name)
        @map[name]
      end

      def []=(name, path)
        @map[name] = lambda do |*args|
          path
        end
        path
      end
    end

    module DSL
      def url(name, path)
        url_map[name] = path
      end
    end

    module Helpers
      def url_for(name, *args)
        self.class.url_map[name].call(*args)
      end
    end
  end

  class Base
    set :url_map, URL::Mapper.new
  end

  register URL
end
