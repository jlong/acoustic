require 'acoustic'

module Acoustic #:nodoc:
  
  # Thrown when the dispatcher cannot resolve a resource from a URL.
  class NotFound < StandardError
    def initialize(uri)
      super "Resource not found for #{uri}"
    end
  end
  
  #
  # The Acoustic::Dispatcher is used by webserver specific dispatchers to
  # service a request and response.
  #
  class Dispatcher
    
    attr_accessor :router
    
    # Create a new dispatcher. Must be initialized with an Acoustic::Router object.
    def initialize(router)
      @router = router
    end
    
    # Service a request and response. Use the router to extract the params from the
    # URL, create the appropriate controller, and had control over to the controller.
    def service(request, response)
      params = @router.resolve_uri(request.request_uri)
      controller = Acoustic::Controller.from_symbol(params[:controller])
      action = params[:action]
      controller.process(action, params, request, response)
    rescue Acoustic::UnresolvableUri, Acoustic::ControllerNameError
      raise Acoustic::NotFound.new(request.request_uri)
    end
    
  end
end