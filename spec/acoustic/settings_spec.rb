require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/settings'

describe Acoustic::Settings do
  it 'should load an empty file without errors' do
    load :empty
  end
  
  it 'should load gems' do
    Kernel.should_receive(:require).with("rubygems")
    Kernel.should_receive(:gem).with("simple")
    Kernel.should_receive(:require).with("simple")
    load :simple_gem_call
  end
  
  it 'should load gem with version' do
    Kernel.should_receive(:require).with("rubygems")
    Kernel.should_receive(:gem).with("versioned", "1.2.3")
    Kernel.should_receive(:require).with("versioned")
    load :gem_call_with_version
  end
  
  it 'should load gem with multiple version requirements' do
    Kernel.should_receive(:require).with("rubygems")
    Kernel.should_receive(:gem).with("versioned", "1.2.3", "1.2.5")
    Kernel.should_receive(:require).with("versioned")
    load :gem_call_with_multiple_versions
  end
  
  def load(symbol)
    @model = @settings = Acoustic::Settings.new
    @settings.load(FIXTURES_ROOT + "/settings/#{symbol}.rb")
  end
end