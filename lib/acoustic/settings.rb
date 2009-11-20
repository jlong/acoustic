require 'acoustic'

module Acoustic
  class Settings < Configuration
    def gem(name, version = nil)
      Kernel.require 'rubygems'
      Kernel.send(:gem, name, version)
      Kernel.require name
    end
  end
end