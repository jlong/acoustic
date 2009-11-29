module Acoustic #:nodoc:
  module ERB
    #
    # This class provides the same API for ERB as the HAML::Engine class for HAML.
    #
    class Engine
      
      # Create a new engine. The first parameter, <tt>string</tt>, should contain
      # the lines that need to be evaluated with ERB.
      # 
      # The options hash can contain one parameter, <tt>:filename</tt>, which should
      # declares the name of the file that <tt>string</tt> was extracted from. Within
      # the context of Acoustic, this would be
      def initialize(string, options = {})
        require 'erb'
        @erb = ::ERB.new(string, nil, '-', '@erbout')
        @erb.filename = options[:filename]
      end
      
      # Render the template that was passed into the initializer on the object passed
      # in as <tt>context</tt>.
      def render(context, &block)
        # We have to keep track of the old erbout variable for nested renders
        # because ERB#result will set it to an empty string before it renders
        old_erbout = context.instance_variable_get('@erbout')
        result = @erb.result(context.instance_eval { binding })
        context.instance_variable_set('@erbout', old_erbout)
        result
      end
      
    end
  end
end