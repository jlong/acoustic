require 'uri'
require 'acoustic'

module Acoustic #:nodoc:
  
  # Thrown when an Acoustic::Router cannot resolve a URI to a controller.
  class UnresolvableUri < StandardError
    def initialize(uri)
      super "Cannot resolve #{uri} to a controller"
    end
  end
  
  #
  # The Acoustic::Router is used to resolve routes (stored in urls.rb) to controllers
  # and parameters.
  #
  class Router
    
    # Create a new router.
    def initialize
      @config = Router::Configuration.new
      @rules = []
    end
    
    # Load a file that contains the route definitions (urls.rb).
    def load(filename)
      @config.load(filename)
      @rules.concat(@config.rules)
      self
    end
    
    # Resolve a URI to the parameters.
    def resolve_uri(uri)
      rule = @rules.find { |r| r.match?(uri) }
      if rule
        rule.extract(uri)
      else
        raise Acoustic::UnresolvableUri.new(uri)
      end
    end
    
    # Class methods for Acoustic::Router
    module ClassMethods
      
      # Load a file that contains route definitions (urls.rb).
      def load(filename)
        new.load(filename)
      end
      
    end
    extend ClassMethods
    
    # Helper Classes
    
    class Rule #:nodoc:
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
        params.merge!(:controller => @options[:controller], :action => @options[:action])
        matches.captures.each_with_index do |value, index|
          key = @capture_symbols[index]
          fail "key should never be nil!" if key.nil?
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
                regexp_parts << "/#{ part_string }"
              else
                regexp_parts << "/#{ Regexp.quote(part) }"
              end
            end
            regexp_parts[-1] = "(?:/#{ part_string }|)" if capture_symbols.last == :action
            regexp = Regexp.new("^#{ regexp_parts.join }/?$")
            [regexp, capture_symbols]
          end
        end
    end
    
    #
    # The Acoustic::Router::Configuration class is a helper class that is used to
    # load and store the information contained in a routes file (urls.rb).
    #
    class Configuration < Acoustic::Configuration
      attr_accessor :rules
      
      def initialize
        @rules = []
      end
      
      # Contect a path with a controller.
      def connect(path, options = {})
        @rules << Rule.new(path, options)
      end
      
      # Moutes a "mini" app at a specific path. Not implemented yet.
      def mount(path, options)
        #noop
      end
      
    end
  end
end