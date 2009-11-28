require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/configuration'

describe Acoustic::Configuration do
  it "should load key/value configuration" do
    config = Acoustic::Configuration.new
    config.load(fixture_filename('configuration/basic.rb'))
    config[:answer].should == 42
    config.to_hash.should == { :answer => 42 }
  end
  
  describe "Class Methods" do
    it "#load should create a new configuration object and load it from a file" do
      config = Acoustic::Configuration.load(fixture_filename('configuration/basic.rb'))
      config[:answer].should == 42
      config.to_hash.should == { :answer => 42 }
    end
  end
end