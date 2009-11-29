module Acoustic #:nodoc:
  #
  # The template for an action is evaluated on Acoustic::View.
  #
  class View < BlankSlate
    
    # The rendered content of the view
    attr_accessor :content
    
    # The controller that is rendering the view
    attr_reader :controller
    
    def initialize(controller)
      @controller = controller
      controller.instance_variables.each do |name|
        instance_variable_set(name, controller.instance_variable_get(name))
      end
      @erbout = nil
    end
    
    def _erbout
      @erbout
    end
    
    def capture_erb(&block)
      # This method has been extracted from Rails
      
      buffer = _erbout
      pos = buffer.length
      block.call
      
      # extract the block 
      data = buffer[pos..-1]
      
      # replace it in the original with empty string
      buffer[pos..-1] = ''
      
      data
    end
    
    #
    # Content_for methods
    #
    
    def content_for(symbol, &block)
      set_content_for(symbol, capture_erb(&block))
    end
    
    def content_for?(symbol)
      !(get_content_for(symbol)).nil?
    end
    
    def get_content_for(symbol = :content)
      if symbol.to_s.intern == :content
        @content
      else
        instance_variable_get("@content_for_#{symbol}")
      end
    end
    
    def set_content_for(symbol, value)
      instance_variable_set("@content_for_#{symbol}", value)
    end
    
    #
    # Render methods
    #
    
    def render(options)
      fail "Unimplemented"
    end
    
  end
end