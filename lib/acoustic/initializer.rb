module Acoustic
  class Initializer
    
    attr_accessor :project_root, :config
    
    def initialize(project_root)
      @project_root = project_root
      add_load_path project_root
      add_load_path project_root + "/lib"
      require "acoustic/settings"
      @config = Settings.new
      initialize_configuration
    end
    
    def run
      config.load(project_root + "/settings.rb")
      load_acoustic
    end
    
    class << self
      attr_accessor :instance
      
      def run(*args)
        @instance ||= new(*args)
        @instance.run 
      end
      
      def method_missing(method, *args)
        @instance.send(method, *args)
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
      
      def load_acoustic
        config[:additional_load_paths].reverse.each { add_load_path(path) }
      end
    
  end
end