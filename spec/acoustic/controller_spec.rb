require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/controller'

describe Acoustic::Controller do
  
  before do
    @controller = Acoustic::Controller.new
    @response = mock("response")
    @controller.instance_variable_set('@_response', @response)
  end
  
  it 'should render text' do
    @response.should_receive(:body=).with("Hello World!")
    @controller.render(:text => "Hello World!")
  end
  
  it 'should render erb templates' do
    @response.should_receive(:body=).with("Hello John!")
    @controller.render(:template => template("hello.erb"))
  end
  
  it 'should render instance variables from the controller to the erb template' do
    @controller.instance_variable_set("@name", "John")
    @response.should_receive(:body=).with("Hello John!")
    @controller.render(:template => template("hello_ivar.erb"))
  end
  
  describe "Class Methods" do
    
    it 'from_symbol should resolve a symbol to a controller' do
      Acoustic::Controller.from_symbol(:test).should == TestController
    end
    
    it 'from_symbol should raise an error if the controller cannot be resolved' do
      lambda { Acoustic::Controller.from_symbol(:bad) }.should raise_error(Acoustic::ControllerNameError, "Undefined controller BadController")
    end
  end
  
  def template(filename)
    fixture_filename("templates", filename)
  end
end