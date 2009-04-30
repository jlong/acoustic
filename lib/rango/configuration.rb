module Rango
  class Configuration
    
    def initialize
      @settings_hash = {}
    end
    
    def load(settings_file_name)
      eval(IO.read(settings_file_name), binding, settings_file_name)
      (local_variables - ["settings_file_name"]).each { |v| self[v] = eval(v, binding) }
    end
    
    def [](key)
      @settings_hash[key.to_sym]
    end
    
    def []=(key, value)
      @settings_hash[key.to_sym] = value
    end
    
    def to_hash
      @settings_hash.dup
    end
    
  end
end