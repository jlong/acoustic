SPEC_ROOT = File.expand_path(File.dirname(__FILE__))
FIXTURES_ROOT = File.expand_path(SPEC_ROOT + '/fixtures')
LIB_ROOT = File.expand_path(SPEC_ROOT + '/../lib')

$LOAD_PATH << LIB_ROOT

class MockController
  def self.process(action, params, request, response)
  end
end

class MockRequest
  attr_accessor :uri
  
  def initialize(uri = "http://localhost/test/show")
    @uri = uri
  end
  
  def request_uri
    URI.parse(@uri)
  end
end

class MockResponse
  attr_accessor :headers, :body
  
  def initialize
    @headers = {}
  end
  
  def []=(key, value)
    @headers[key] = value
  end
  
  def [](key)
    @headers[key]
  end
end

def fixture_filename(*path_parts)
  File.expand_path(File.join(FIXTURES_ROOT, *path_parts))
end