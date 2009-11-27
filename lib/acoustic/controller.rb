require 'acoustic'

module Acoustic
  class Controller
    
    def process(action, params, request, response)
      @_params, @_request, @_response = params, request, response
      response['Content-Type'] = "text/html"
      @_rendered = false
      send(action) if respond_to?(action)
      unless @_rendered
        template = template_for(action)
        if template
          render :template => template
        else
          raise TemplateNotFound.new(self, action)
        end
      end
    end
    
    def render(options)
      case
      when options.has_key?(:text)
        response.body = options[:text]
      when options.has_key?(:template)
        filename = options[:template]
        string = IO.read(filename)
        view = View.new(self)
        engine = engine_for(string, :filename => filename)
        response.body = engine.render(view)
      else
        raise 'invalid options passed to render'
      end
      @_rendered = true
    end
    
    def template_for(action)
      name = self.class.name
      name = $1 if name =~ /^(.*?)Controller$/
      name = Inflector.underscore(name)
      relative_template_for("#{ name }_#{ action }")
    end
    
    def relative_template_for(filename)
      actual_filename = nil
      template_load_paths.find do |path|
        actual_filename = File.expand_path(File.join(path, "#{ filename }.html.erb"))
        File.file?(actual_filename)
      end
      actual_filename
    end
    
    module ClassMethods
      
      attr_reader :filename
      
      def inherited(klass)
        # determine the filename where the class was defined
        begin
          raise
        rescue => e
          line = e.backtrace[1]
          klass.instance_variable_set("@filename", $1) if line.match(/^(.*?):/)
        end
      end
      
      def template_load_paths
        @template_load_paths ||= [ File.expand_path(File.dirname(self.filename)) ]
      end
      
      def process(*args)
        new.process(*args)
      end
      
      def from_symbol(symbol)
        name = Inflector.camelize("#{symbol}_controller")
        Inflector.constantize(name)
      rescue NameError
        raise Acoustic::ControllerNameError.new(name)
      end
      
    end
    extend ClassMethods
    
    protected
      
      def request
        @_request
      end
      
      def response
        @_response
      end
      
      def params
        @_params
      end
      
      def engine_for(string, options = {})
        ERB::Engine.new(string, :filename => options[:filename])
      end
      
      def template_load_paths
        @template_load_paths ||= self.class.template_load_paths
      end
    
  end
end