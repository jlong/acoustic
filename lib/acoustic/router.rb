require 'uri'
require 'acoustic'

module Acoustic
  class Router
    
    def initialize
      @config = Router::Configuration.new
      @rules = []
    end
    
    def load(filename)
      @config.load(filename)
      @rules.concat(@config.rules)
      self
    end
    
    def resolve_uri(uri)
      rule = @rules.find { |r| r.match?(uri) }
      if rule
        rule.extract(uri)
      else
        raise Acoustic::UnresolvableUriError
      end
    end
    
    # Class Methods
    def self.load(filename)
      new.load(filename)
    end
    
    # Helper Classes
    
    class Rule
      def initialize(path, options)
        @path, @options = path, options
        @regexp, @capture_symbols = extract_regexp_and_capture_symbols(path)
        @options[:action] = :index unless @options.has_key? :action
      end
      
      def match?(uri)
        !@regexp.match(uri.path).nil?
      end
      
      def extract(uri)
        matches = @regexp.match(uri.path)
        params = extract_params(uri)
        params[:controller] = @options[:controller] if @options.has_key? :controller
        params[:action] = @options[:action] if @options.has_key? :action
        matches.captures.each_with_index do |value, index|
          key = @capture_symbols[index]
          raise "key should never be nil!" if key.nil?
          value = value.intern if [:controller, :action].include?(key) && !value.nil?
          params[key] = value unless value.nil?
        end
        params
      end
      
      private
        
        def extract_params(uri)
          q = uri.query
          if q
            pairs = q.split('&')
            pairs.inject({}) { |h, pair| k,v = pair.split('=', 2); h[k.intern] = v; h }
          else
            {}
          end
        end
        
        def extract_regexp_and_capture_symbols(path)
          if path == "*"
            [%r{^(.*?)/?$}, [:url]]
          else
            part_string = "([A-Za-z0-9,_-]+)"
            regexp_parts = []
            capture_symbols = []
            path_parts = path.split(%r{/})
            path_parts.reject! { |p| p.empty? }
            path_parts.each do |part|
              if part =~ /^:([A-Za-z_]+)$/
                capture_symbols << $1.intern
                regexp_parts << part_string
              else
                regexp_parts << Regexp.quote(part)
              end
            end
            if capture_symbols.last == :action
              regexp = Regexp.new("^/#{ (regexp_parts[0...-1]).join('/') }(?:/#{ part_string }|)/?$")
            else
              regexp = Regexp.new("^/#{ regexp_parts.join('/') }/?$")
            end
            [regexp, capture_symbols]
          end
        end
    end
    
    class Configuration < Acoustic::Configuration
      attr_accessor :rules
      
      def initialize
        @rules = []
      end
      
      def connect(path, options = {})
        @rules << Rule.new(path, options)
      end
      
      def mount(path, options)
        #noop
      end
      
    end
  end
end