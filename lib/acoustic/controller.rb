require 'acoustic'

module Acoustic
  class Controller
    
    class ViewContext < BlankSlate      
      def initialize(controller)
        @controller = controller
        @controller.instance_variables.each do |ivar|
          instance_variable_set(ivar, @controller.instance_variable_get(ivar))
        end
        @erbout = nil
      end
      
      def _erbout
        @erbout
      end
    end
    
    def process(action, params, request, response)
      @_params, @_request, @_response = params, request, response
      response['Content-Type'] = "text/html"
      send(action)
      render :template => template_for(action)
    end
    
    def render(options)
      case
      when options.has_key?(:text)
        response.body = options[:text]
      when options.has_key?(:template)
        filename = options[:template]
        string = IO.read(filename)
        context = ViewContext.new(self)
        engine = engine_for(string, :filename => filename)
        response.body = engine.render(context)
      else
        raise 'invalid options passed to render'
      end
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
      
      def template_path
        File.expand_path(File.dirname(filename))
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
      
      def template_for(action)
        name = self.class.name
        name = $1 if name =~ /^(.*?)Controller$/
        name = Inflector.underscore(name)
        "#{ File.dirname(self.class.filename) }/#{ name }_#{ action }.html.erb"
      end
      
      def engine_for(string, options = {})
        ERB::Engine.new(string, :filename => options[:filename])
      end
      
  end
end