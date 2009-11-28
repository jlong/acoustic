module Acoustic
  #
  # The Acoustic::Configuration class provides a base class for the many different
  # kinds of configuration used by Acoustic, including Acoustic::Settings and
  # Acoustic::Router::Configuration.
  # 
  # The main idea behind this object is to provide a way to capture the values
  # stored in local variables inside of a Ruby file. This allows you to use
  # Ruby style assignment for configuration.
  # 
  # For example, a simple configuration file could look like this:
  # 
  #  question = "What is the answer to all of life and the universe?"
  #  answer = 42
  # 
  # You could then load this with Acoustic::Configuration like this:
  # 
  #  config = Acoustic::Configuration.new
  #  config.load("path/to/config.rb")
  #  config[:question] #=> "What is the answer to all of life and the universe?"
  #  config[:answer]   #=> 42
  # 
  # The Acoustic::Configuration class is not really meant to be used directly,
  # but rather as an abstract base class. Subclasses can define their own methods
  # which can be used inside of configuration file. Configuration files are evaluated
  # on a class.
  # 
  class Configuration
    
    # Create a new configuration object.
    def initialize
      @_hash = {}
    end
    
    # Load settings contained in filename into the configuration hash.
    def load(config_filename)
      eval(IO.read(config_filename), binding, config_filename)
      (local_variables - ["config_filename"]).each { |v| self[v] = eval(v, binding) }
      self
    end
    
    # After settings have been loaded this method can be used to access each of
    # the settings variables in the configuration hash.
    def [](key)
      @_hash[key.to_sym]
    end
    
    # Set a variable in the configuration hash. This will have no effect on the local
    # variables that are defined inside of a configuration file. It is meant to be used
    # after the Configuration#load is called.
    def []=(key, value)
      @_hash[key.to_sym] = value
    end
    
    # Convert the configuration into a Hash.
    def to_hash
      @_hash.dup
    end
    
    # Class methods for Acoustic::Configuration.
    module ClassMethods
      
      # Load settings contained in filename into the configuration hash.
      def load(filename)
        new.load(filename)
      end
      
    end
    extend ClassMethods
  end
end