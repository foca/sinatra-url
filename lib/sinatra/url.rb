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
        @map[name] = Route.new(path)
      end
    end

    class Route
      def initialize(path)
        @path = path
        @pattern, @keys = compile(path)
      end

      def match(str)
        @pattern.match(str)
      end

      def keys
        @keys
      end

      def call(params)
        params[:splat] = Array(params[:splat])
        url = @path.dup
        keys.each do |key|
          match = key == "splat" ? "*" : ":#{key}"
          replacement = key == "splat" ? params[:splat].shift : params[key.to_sym]
          url.sub! match, replacement
        end
        url
      end

      private

      def compile(path)
        keys = []
        if path.respond_to? :to_str
          special_chars = %w{. + ( )}
          pattern =
            path.to_str.gsub(/((:\w+)|[\*#{special_chars.join}])/) do |match|
              case match
              when "*"
                keys << 'splat'
                "(.*?)"
              when *special_chars
                Regexp.escape(match)
              else
                keys << $2[1..-1]
                "([^/?&#]+)"
              end
            end
          [/^#{pattern}$/, keys]
        elsif path.respond_to? :match
          [path, keys]
        else
          raise TypeError, path
        end
      end
    end

    module DSL
      def url(name, path)
        url_map[name] = path
        path
      end
    end

    module Helpers
      def url_for(name, params={})
        self.class.url_map[name].call(params)
      end
    end
  end

  class Base
    set :url_map, URL::Mapper.new
  end

  register URL
end
