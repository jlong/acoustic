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
  
  def template(filename)
    File.join(FIXTURES_ROOT, "templates", filename)
  end
end