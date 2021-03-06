require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/controller'

require fixture_filename("controller", "controllers")

describe Acoustic::Controller do
  
  before :each do
    @controller = TestController.new
    @request = MockRequest.new
    @response = MockResponse.new
    @controller.instance_variable_set('@_request', @request)
    @controller.instance_variable_set('@_response', @response)
  end
  
  describe '#redirect_to' do
    it 'should redirect and not render the default template' do
      @controller.redirect_to 'this/path'
      @response['location'].should == 'http://localhost/this/path'
      @response['status'].should == '302 Found'
      @response.body.should match(%r{this/path})
      @controller.should be_rendered
    end
  end
  
  describe '#render' do
    it 'should render text' do
      @controller.render(:text => "Hello World!")
      @response.body.should =~ /Hello World!/
    end
    
    it 'should render erb templates' do
      render("hello.erb")
      @response.body.should =~ /Hello John!/
    end
    
    it 'should render instance variables from the controller to the erb template' do
      @controller.instance_variable_set("@name", "John")
      render("hello_ivar.erb")
      @response.body.should =~ /Hello John!/
    end
    
    def render(filename)
      @controller.render(:template => template(filename))
    end
  end
  
  describe '#process' do
    
    before :each do
      @params = {}
    end
    
    it 'should set params, request, and response' do
      process
      @controller.send(:params).should be(@params)
      @controller.send(:request).should be(@request)
      @controller.send(:response).should be(@response)
    end
    
    it 'should set the content type on the response' do
      process
      @response.headers["Content-Type"].should == "text/html"
    end
    
    it 'should call the appropriate action' do
      @controller.should_receive(:show)
      process
      
      @controller.should_receive(:index)
      process(:index)
    end
    
    it 'should render the correct template for the action' do
      process
      @response.body.should =~ /Hello World/
    end
    
    it 'should render the template even if the method for the action does not exist' do
      process(:index)
      @response.body.should =~ /Testing 1, 2, 3.../
    end
    
    it 'should raise an Acoustic::TemplateNotFound error if the template does not exist for the action' do
      lambda { process(:no_template) }.should raise_error(Acoustic::TemplateNotFound)
    end
    
    it 'should raise an Acoustic::ActionNameError if neither the action nor the template exists' do
      lambda { process(:no_action_or_template) }.should raise_error(Acoustic::ActionNameError)
    end
    
    it 'should render a template with the layout in the same directory' do
      process(:index)
      @response.body.should =~ /<html/
    end
    
    def process(action = :show, params = @params, request = @request, response = @response)
      @controller.process(action, params, request, response)
    end
  end
  
  describe "Class Methods" do
    it 'from_symbol should resolve a symbol to a controller' do
      Acoustic::Controller.from_symbol(:mock).should == MockController
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