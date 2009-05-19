require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'uri'
require 'acoustic/controller'
require 'acoustic/url_mapper'

class TestController < Acoustic::Controller
  def first; end
  def second; end
end

class AnotherTestController < Acoustic::Controller
  def index; end
end

describe Acoustic::UrlMapper do
  
  before do
    @mapper = Acoustic::UrlMapper.new
  end
  
  it 'should load an empty file without errors' do
    load :empty
  end
  
  it 'should resolve a URI with a basic connect statement' do
    load :basic
    @mapper.resolve_uri(URI.parse('http://localhost/first')).should == [TestController, :first, {}]
    @mapper.resolve_uri(URI.parse('http://localhost/second')).should == [TestController, :second, {}]
    @mapper.resolve_uri(URI.parse('http://localhost/another')).should == [AnotherTestController, :index, {}]
    @mapper.resolve_uri(URI.parse('http://localhost/another?test=1')).should == [AnotherTestController, :index, {:test=>'1'}]
  end
  
  def load(symbol)
    @mapper.load(FIXTURES_ROOT + "/urls/#{symbol}.rb")
  end

end