require 'acoustic'

module Acoustic #:nodoc:
  #
  # The Acoustic::Settings class is used to load and store the information
  # contained in an Acoustic settings file (settings.rb).
  #
  class Settings < Configuration
    
    # Specify a dependancy on a certain gem and insure that it is loaded before
    # any of the application logic is executed.
    def gem(name, *version_requirements)
      Kernel.require 'rubygems'
      Kernel.send(:gem, name, *version_requirements)
      Kernel.require name
    end
    
  end
end