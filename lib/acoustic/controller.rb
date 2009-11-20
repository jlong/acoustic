require 'acoustic'

module Acoustic
  class Controller
    
    class ViewContext #< BlankObject
      def initialize(controller)
        @controller = controller
        @controller.instance_variables.each do |ivar|
          instance_variable_set(ivar, @controller.instance_variable_get(ivar))
        end
      end
    end
    
    def process(action, params, request, response)
      @_params, @_request, @_response = params, request, response
      response['Content-Type'] = "text/html"
      send(action)
    end
    
    def render(options)
      case
      when options.has_key?(:text)
        response.body = options[:text]
      when options.has_key?(:template)
        require 'erb'
        filename = options[:template]
        lines = IO.read(filename)
        template = ERB.new(lines, 0, "%")
        context = ViewContext.new(self)
        response.body = template.result(context.instance_eval { binding })
      else
        raise 'invalid options passed to render'
      end
    end
    
    # Class Methods
    def self.process(*args)
      new.process(*args)
    end
    
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
    
  end
end