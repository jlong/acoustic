require 'acoustic/configuration'

module Acoustic
  class Settings < Configuration
    def gem(name, version = nil)
      require 'rubygems'
      Kernel.send(:gem, name, version)
      require name
    end
  end
end