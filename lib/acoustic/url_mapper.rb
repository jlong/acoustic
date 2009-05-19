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
      attr_accessor :path, :controller_symbol, :action
      
      def initialize(path, controller_symbol, action)
        @path, @controller_symbol, @action = path, controller_symbol, action
      end
      
      def match?(uri)
        match_path = uri.path
        match_path = $1 if match_path =~ %r{^/(.*)$}
        path == match_path
      end
      
      def extract(uri)
        [controller, action, extract_params(uri)]
      end
      
      def controller
        @controller ||= constantize(camelize("#{controller_symbol}_controller"))
      end
      
      private
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
    end
    
    class Configuration < Acoustic::Configuration
      attr_accessor :rules
      
      def initialize
        @rules = []
      end
      
      def connect(path, options)
        @rules << Rule.new(path, options[:controller], options[:action])
      end
      
      def mount(path, options)
        
      end
      
    end
  end
end