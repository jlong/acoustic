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
  
  it 'should load an empty file without errors' do
    load :empty
  end
  
  it 'should resolve a URI with a basic connect statement' do
    load :basic
    resolve('/first').should == [TestController, :first, {}]
    resolve('/second').should == [TestController, :second, {}]
    resolve('/another').should == [AnotherTestController, :index, {}]
    resolve('/another?test=1').should == [AnotherTestController, :index, {:test=>'1'}]
    resolve('/another?test1=1&test2=2').should == [AnotherTestController, :index, {:test1=>'1', :test2=>'2'}]
  end
  
  it 'should resolve a URI with params in the path' do
    load :params
    resolve('/test/first').should == [TestController, :first, {}]
    resolve('/test/second').should == [TestController, :second, {}]
    resolve('/another_test/index').should == [AnotherTestController, :index, {}]
  end
  
  def load(symbol)
    @mapper = Acoustic::UrlMapper.new
    @mapper.load(FIXTURES_ROOT + "/urls/#{symbol}.rb")
  end
  
  def resolve(path)
    @mapper.resolve_uri(URI.parse("http://localhost#{path}"))
  end
end