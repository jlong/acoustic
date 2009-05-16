require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/configuration'

describe Acoustic::Configuration do
  it "load basic configuration" do
    config = Acoustic::Configuration.new
    config.load(FIXTURES_ROOT + '/configuration/basic.rb')
    config[:answer].should == 42
  end
end