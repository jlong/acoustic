require 'acoustic/url_mapper'
require 'acoustic/controller'

module Acoustic
  class Dispatcher
    
    def initialize(project_root, config)
      @config = config
      @mapper = UrlMapper.load(File.join(project_root, 'urls.rb'))
    end
    
    def service(request, response)
      controller, action, params = @mapper.resolve_uri(request.request_uri)
      controller.process(action, params, request, response)
    end
    
  end
end