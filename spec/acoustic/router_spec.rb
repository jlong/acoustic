require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'acoustic/router'

describe Acoustic::Router do
  
  it 'should load an empty file without errors' do
    load :empty
  end
  
  it 'should resolve a URI with a basic connect statement' do
    load :basic
    resolve('/first').should == {:controller => :test, :action => :first}
    resolve('/second').should == {:controller => :test, :action => :second}
    resolve('/another/').should == {:controller => :another_test, :action => :index}
    resolve('/another?test=1').should == {:controller => :another_test, :action => :index, :test=>'1'}
    resolve('/another/?test1=1&test2=2').should == {:controller => :another_test, :action => :index, :test1=>'1', :test2=>'2'}
  end
  
  it 'should resolve a URI with params in the path' do
    load :params
    resolve('/test/first').should == {:controller => :test, :action => :first}
    resolve('/test/second').should == {:controller => :test, :action => :second}
    resolve('/another_test/index').should == {:controller => :another_test, :action => :index}
  end
  
  it 'should raise an error when the URI cannot be resolved' do
    load :empty
    lambda { resolve('/unresolvable') }.should raise_error(Acoustic::UnresolvableUri)
  end
  
  it 'should allow a wildcard rule' do
    load :wildcard
    resolve('/wildness').should == {:controller => :wildcard, :action=> :show, :url => "/wildness"}
  end
  
  it 'should resolve a URI without an action to the :index action' do
    load :params
    resolve('/test').should == {:controller => :test, :action => :index}
  end
  
  def load(symbol)
    @router = Acoustic::Router.new
    @router.load(fixture_filename("urls", "#{symbol}.rb"))
  end
  
  def resolve(path)
    @router.resolve_uri(URI.parse("http://localhost#{path}"))
  end
end