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
      def self.default
        @default ||= new
      end

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
          unless url.sub! match, replacement
            get_params[key] = params[key.to_sym]
          end
        end

        get_params = params.map do |key, value|
          next if key == :splat || keys.include?(key.to_s)
          "#{key}=#{value}"
        end.compact

        url << "?#{get_params.join('&')}" unless get_params.empty?
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
      def url(name, path=nil)
        Mapper.default[name] = path unless path.nil?
        Mapper.default[name] or raise ArgumentError, "Unregistered path for '#{name}'"
      end
    end

    module Helpers
      def url_for(name, params={})
        route = Mapper.default[name] or raise ArgumentError, "Unregistered path for '#{name}'"
        route.call(params)
      end
    end
  end

  register URL
end
