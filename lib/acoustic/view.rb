module Acoustic #:nodoc:
  #
  # The template for an action is evaluated on Acoustic::View.
  #
  class View < BlankSlate
    
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
    
=begin
    # This is extracted from Rails
    def capture_erb(&block)
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
      partial = options.delete(:partial)
      template = options.delete(:template)
      case
      when partial
        render_partial(partial)
      when template
        render_template(template)
      else
        raise "render options not supported #{options.inspect}"
      end
    end
    
    protected
      
      def render_partial(partial)
        render_template(partial, :partial => true)
      end
      
      def render_template(template, options={})
        path = File.dirname(parser.script_filename)
        if template =~ %r{^/}
          template = template[1..-1]
          path = Dir.pwd
        end
        filename = template_filename(File.join(path, template), :partial => options.delete(:partial))
        if File.file?(filename)
          parser.parse_file(filename)
        else
          raise "File does not exist #{filename.inspect}"
        end
      end
      
      def template_filename(name, options)
        path = File.dirname(name)
        template = File.basename(name)
        template = "_" + template if options.delete(:partial)
        template += extname(parser.script_filename) unless name =~ /\.[a-z]{3,4}$/
        File.join(path, template)
      end
      
      def extname(filename)
        /(\.[a-z]{3,4}\.[a-z]{3,4})$/.match(filename)
        $1 || File.extname(filename) || ''
      end
=end
  end
end