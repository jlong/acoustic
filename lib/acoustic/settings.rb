require 'acoustic'

module Acoustic
  class Settings < Configuration
    
    def gem(name, *version_requirements)
      Kernel.require 'rubygems'
      Kernel.send(:gem, name, *version_requirements)
      Kernel.require name
    end
    
  end
end