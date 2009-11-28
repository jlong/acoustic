require 'webrick'
require 'acoustic'

module Acoustic
  
  #
  # A Servelet for Webrick that services an Acoustic application.
  #
  class DispatchServlet < WEBrick::HTTPServlet::AbstractServlet
    
    def initialize(server, options)
      @initializer = Initializer.instance
      @file_handler = WEBrick::HTTPServlet::FileHandler.new(server, options[:server_root])
      @router = @initializer.router
      @dispatcher = Acoustic::Dispatcher.new(@router)
    end
    
    def service(request, response)
      handle_dispatch(request, response) unless handle_file(request, response)
    end
    
    def handle_file(request, response)
      begin
        @file_handler.send(:service, request, response)
        true
      rescue WEBrick::HTTPStatus::PartialContent, WEBrick::HTTPStatus::NotModified => error
        response.set_error(error)
        true
      rescue => error
        false
      end
    end
    
    def handle_dispatch(request, response)
      begin
        @dispatcher.service(request, response)
      rescue Acoustic::NotFound
        raise WEBrick::HTTPStatus::NotFound
      end
    end
    
    module ClassMethods
      def dispatch(options)
        server = WEBrick::HTTPServer.new(
          :BindAddress => options[:ip],
          :Port => options[:port],
          :DocumentRoot => options[:server_root]
        )
        server.mount('/', self, options)
        trap("INT") { server.shutdown }
        server.start
      end
    end
    extend ClassMethods
    
  end
end