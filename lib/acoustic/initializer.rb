module Acoustic
  class Initializer
    
    attr_accessor :project_root, :config, :router
    
    def initialize(project_root)
      @project_root = project_root
      add_load_path project_root
      add_load_path project_root + "/lib"
      require "acoustic"
      @config = Settings.new
      @router = Router.load(project_root + "/urls.rb")
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