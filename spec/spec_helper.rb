SPEC_ROOT = File.expand_path(File.dirname(__FILE__))
FIXTURES_ROOT = File.expand_path(SPEC_ROOT + '/fixtures')
LIB_ROOT = File.expand_path(SPEC_ROOT + '/../lib')

$LOAD_PATH << LIB_ROOT

class TestController
  def self.process(action, params, request, response)
  end
end

def fixture_filename(*path_parts)
  File.expand_path(File.join(FIXTURES_ROOT, *path_parts))
end