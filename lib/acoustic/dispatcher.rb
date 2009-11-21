require 'acoustic'

module Acoustic
  class Dispatcher
    
    attr_accessor :router
    
    def initialize(router)
      @router = router
    end
    
    def service(request, response)
      params = @router.resolve_uri(request.request_uri)
      controller = Controller.from_symbol(params[:controller])
      action = params[:action]
      controller.process(action, params, request, response)
    rescue Acoustic::UnresolvableUriError, Acoustic::ControllerNameError
      raise Acoustic::NotFoundError.new(request.request_uri)
    end
    
  end
end