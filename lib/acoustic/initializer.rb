module Acoustic #:nodoc:
  #
  # The Acoustic::Initializer bootstraps an Acoustic project. It adds the appropriate
  # directories to the load path and loads the settings.rb and urls.rb files in the
  # root of the project.
  #
  # There is no need to use this class directly within your project.
  #
  class Initializer
    
    attr_accessor :project_root, :settings, :router
    
    # Create a new Initializer. The <tt>project_root</tt> is the top-level directory
    # of an Acoustic project.
    def initialize(project_root)
      @project_root = project_root
      
      add_load_path File.expand_path(File.join(File.dirname(__FILE__), '..'))
      add_load_path project_root
      add_load_path project_root + "/lib"
      
      require "acoustic"
      
      @settings = Settings.new
      initialize_settings
      
      @router = Router.new
    end
    
    # Load and initialize Acoustic.
    def run
      load_settings
      load_urls
    end
    
    module ClassMethods
      
      # Stores the initializer that was first used to bootstrap acoustic
      attr_accessor :instance
      
      # Create a new initializer and run it in the <tt>project_root</tt>.
      def run(*args)
        @instance ||= new(*args)
        @instance.run 
      end
    end
    extend ClassMethods
    
    private
      
      # Add <tt>path</tt> to the begining of the load path.
      def add_load_path(path)
        $LOAD_PATH.unshift(path)
        $LOAD_PATH.uniq!
      end
      
      # Set the default settings
      def initialize_settings
        settings[:additional_load_paths] = []
      end
      
      # Load the settings.rb file in the <tt>project_root</tt>.
      def load_settings
        settings.load(project_root + "/settings.rb")
        settings[:additional_load_paths].reverse.each { add_load_path(path) }
      end
      
      # Load urls.rb into the Acoustic::Router.
      def load_urls
        router.load(project_root + "/urls.rb")
      end
    
  end
end