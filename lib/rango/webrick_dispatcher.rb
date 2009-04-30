require 'webrick'
require 'rango/dispatcher'

class DispatchServlet < WEBrick::HTTPServlet::AbstractServlet

  def self.dispatch(options)
    server = WEBrick::HTTPServer.new(
      :BindAddress => options[:ip],
      :Port => options[:port],
      :DocumentRoot => options[:server_root]
    )
    server.mount('/', self, options)
    trap("INT") { server.shutdown }
    server.start
  end
  
  def initialize(server, options)
    @file_handler = WEBrick::HTTPServlet::FileHandler.new(server, options[:server_root])
    @dispatcher = Rango::Dispatcher.new
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
    @dispatcher.process(request, response)
  end
  
end