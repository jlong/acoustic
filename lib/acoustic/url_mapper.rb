require 'acoustic/configuration'

module Acoustic
  class UrlMapper
    
    def initialize
      @config = UrlMapper::Configuration.new
      @rules = []
    end
    
    def load(filename)
      @config.load(filename)
      @rules.concat(@config.rules)
      self
    end
    
    # Class Methods
    def self.load(filename)
      new.load(filename)
    end
    
    def resolve_uri(uri)
      rule = @rules.find { |r| r.match?(uri) }
      controller, action, params = rule.extract(uri)
    end
    
    # Helper Classes
    
    class Rule
      def initialize(path, options)
        @path, @options = path, options
        @regexp, @capture_symbols = extract_regexp_and_capture_symbols(path)
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
          value = value.intern if [:controller, :action].include?(key)
          params[key] = value
        end
        controller, action = controller_from_symbol(params.delete(:controller)), params.delete(:action)
        [controller, action, params]
      end
      
      private
        
        def controller_from_symbol(symbol)
          constantize(camelize("#{symbol}_controller"))
        end
        
        def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
          if first_letter_in_uppercase
            lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
          else
            lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
          end
        end
        
        def constantize(camel_cased_word)
          names = camel_cased_word.split('::')
          names.shift if names.empty? || names.first.empty?
          constant = Object
          names.each do |name|
            constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
          end
          constant
        end
        
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
          regexp_parts = []
          capture_symbols = []
          path_parts = path.split(%r{/})
          path_parts.reject! { |p| p.empty? }
          path_parts.each do |part|
            if part =~ /^:([a-z_]+)$/
              capture_symbols << $1.intern
              regexp_parts << "([A-Za-z0-9,_-]+)"
            else
              regexp_parts << Regexp.quote(part)
            end
          end
          regexp = Regexp.new("^/#{regexp_parts.join('/')}$")
          [regexp, capture_symbols]
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
        
      end
      
    end
  end
end