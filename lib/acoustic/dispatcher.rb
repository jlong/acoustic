module Acoustic
  class Dispatcher
    def process(request, response)
      response['Content-Type'] = "text/html"
      response.body = "Hello World!"
    end
  end
end