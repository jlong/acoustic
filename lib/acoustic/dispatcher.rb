require 'acoustic'

module Acoustic
  
  # Thrown when the dispatcher cannot resolve a resource from a URL.
  class NotFound < StandardError
    def initialize(uri)
      super "Resource not found for #{uri}"
    end
  end
  
  class Dispatcher
    
    attr_accessor :router
    
    def initialize(router)
      @router = router
    end
    
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