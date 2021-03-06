require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/dispatcher'
require 'uri'

describe Acoustic::Dispatcher do
  
  before do
    @request = MockRequest.new
    @response = Object.new
  end
  
  it 'should initialize with a router' do
    @router = Object.new
    @dispatcher = Acoustic::Dispatcher.new(@router)
    @dispatcher.router.should be(@router)
  end
  
  it 'should service a request and response' do
    @router = Object.new
    @params = {:controller => :test, :action => :show}
    @router.should_receive(:resolve_uri).and_return(@params)
    Acoustic::Controller.should_receive(:from_symbol).with(:test).and_return(MockController)
    MockController.should_receive(:process).with(:show, @params, @request, @response)
    service(@request, @response)
  end
  
  it 'should rescue Acoustic::UnresolvableUriError and raise an Acoustic::NotFound' do
    @router = Acoustic::Router.load(fixture_filename("dispatcher", "one_controller_urls.rb"))
    @request = MockRequest.new("http://localhost/404")
    lambda { service(@request, @response) }.should raise_error(Acoustic::NotFound, "Resource not found for http://localhost/404")
  end
  
  it 'should rescue Acoustic::ControllerNameError when the controller is not found and raise an Acoustic::NotFound' do
    @request = MockRequest.new("http://localhost/bad")
    lambda {
      service(@request, @response)
    }.should raise_error(Acoustic::NotFound, "Resource not found for http://localhost/bad")    
  end
  
  def service(request, response)
    @router ||= Acoustic::Router.load(fixture_filename("dispatcher", "urls.rb"))
    @dispatcher = Acoustic::Dispatcher.new(@router)
    @dispatcher.service(request, response)
  end
  
end