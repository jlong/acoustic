require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/controller'

class TestController < Acoustic::Controller
  def show
    @name = "world"
  end
end

describe Acoustic::Controller do
  
  before :each do
    @controller = Acoustic::Controller.new
    @request = MockRequest.new
    @response = MockResponse.new
    @controller.instance_variable_set('@_response', @response)
  end
  
  describe '#render' do
    it 'should render text' do
      @response.should_receive(:body=).with("Hello World!")
      @controller.render(:text => "Hello World!")
    end
    
    it 'should render erb templates' do
      @response.should_receive(:body=).with("Hello John!")
      render("hello.erb")
    end
    
    it 'should render instance variables from the controller to the erb template' do
      @controller.instance_variable_set("@name", "John")
      @response.should_receive(:body=).with("Hello John!")
      render("hello_ivar.erb")
    end
    
    def render(filename)
      @controller.render(:template => template(filename))
    end
  end
  
  describe '#process' do
    before :each do
      @controller = TestController.new
      @action = :show
      @params = {}
    end
    
    it 'should set appropriate instance variables' do
      process(:show)
      @controller.instance_variable_get("@_params").should be(@params)
      @controller.instance_variable_get("@_request").should be(@request)
      @controller.instance_variable_get("@_response").should be(@response)
    end
    
    it 'should set the content type on the response' do
      @response.should_receive(:[]=).with("Content-Type", "text/html")
      process(:show)
    end
    
    it 'should call the appropriate action' do
      @controller.should_receive(:show)
      process(:show)
      
      @controller.should_receive(:index)
      process(:index)
    end
    
    it 'should render the correct template for the action' 
    
    def process(action = :show)
      @controller.process(action, @params, @request, @response)
    end
  end
  
  describe "Class Methods" do
    it 'from_symbol should resolve a symbol to a controller' do
      Acoustic::Controller.from_symbol(:test).should == TestController
    end
    
    it 'from_symbol should raise an error if the controller cannot be resolved' do
      lambda {
        Acoustic::Controller.from_symbol(:bad)
      }.should raise_error(Acoustic::ControllerNameError, "Undefined controller BadController")
    end
  end
  
  def template(filename)
    fixture_filename("templates", filename)
  end
end