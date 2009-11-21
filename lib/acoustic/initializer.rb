module Acoustic
  class Initializer
    
    attr_accessor :project_root, :settings, :router
    
    def initialize(project_root)
      @project_root = project_root
      
      add_load_path project_root
      add_load_path project_root + "/lib"
      
      require "acoustic"
      
      @settings = Settings.new
      initialize_settings
      
      @router = Router.new
    end
    
    def run
      load_settings
      load_urls
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
      
      def initialize_settings
        settings[:additional_load_paths] = []
      end
      
      def load_settings
        settings.load(project_root + "/settings.rb")
        settings[:additional_load_paths].reverse.each { add_load_path(path) }
      end
      
      def load_urls
        router.load(project_root + "/urls.rb")
      end
    
  end
end