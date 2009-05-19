require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/controller'

describe Acoustic::Controller do

  it 'should render text' do
    controller = Acoustic::Controller.new
    response = mock("response")
    controller.instance_variable_set('@_response', response)
    response.should_receive(:body=).with("Hello World!")
    controller.render(:text => "Hello World!")
  end

end