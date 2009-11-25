module Acoustic
  module ERB
    class Engine
      def initialize(string, options = {})
        require 'erb'
        @erb = ::ERB.new(string, nil, '-', '@erbout')
        @erb.filename = options[:filename]
      end
      
      def render(context, &block)
        # we have to keep track of the old erbout variable for nested renders
        # because ERB#result will set it to an empty string before it renders
        old_erbout = context.instance_variable_get('@erbout')
        result = @erb.result(context.instance_eval { binding })
        context.instance_variable_set('@erbout', old_erbout)
        result
      end
    end
  end
end