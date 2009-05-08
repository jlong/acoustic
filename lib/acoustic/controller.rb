module Acoustic
  class Controller
    
    def process(action, params, request, response)
      @_params, @_request, @_response = params, request, response
      response['Content-Type'] = "text/html"
      send(action)
    end
    
    def render(options)
      response.body = options[:text]
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