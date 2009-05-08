require 'acoustic/configuration'

module Acoustic
  class UrlMapper
    
    def initialize
      @config = UrlMapper::Configuration.new
    end
    
    def load(filename)
      @config.load(filename)
      self
    end
    
    # Class Methods
    def self.load(filename)
      new.load(filename)
    end
    
    def resolve_uri(uri)
      require 'hello/controllers'
      controller, action, params = HelloController, :show, {}
    end
    
    # Helper Classes
    
    class Configuration < Acoustic::Configuration
      def mount(path, options)
        
      end
      
      def connect(path, options)
        
      end
    end
  end
end