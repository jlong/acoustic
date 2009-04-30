module Rango
  class Initializer
    
    attr_accessor :project_root, :config
    
    def initialize(project_root)
      @project_root = project_root
      add_load_path project_root
      add_load_path project_root + "/lib"
      require "rango/configuration"
      @config = Configuration.new
      initialize_configuration
    end
    
    def run
      config.load(project_root + "/settings.rb")
      load_rango
    end
    
    class << self
      attr_accessor :instance
      
      def run(*args)
        @instance ||= new(*args)
        @instance.run 
      end
    end
    
    private
    
      def add_load_path(path)
        $LOAD_PATH.unshift(path)
        $LOAD_PATH.uniq!
      end
      
      def initialize_configuration
        config[:additional_load_paths] = []
      end
      
      def load_rango
        config[:additional_load_paths].reverse.each { add_load_path(path) }
      end
  end
end