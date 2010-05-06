require 'acoustic'

module Acoustic #:nodoc:
  
  # Thrown when a controller cannot find a template for a given action.
  class TemplateNotFound < NameError
    def initialize(controller, action)
      super("Template not found for #{controller}##{action}")
    end
  end
  
  # Thrown when accoustic cannot resolve a URL to a controller.
  class ControllerNameError < NameError
    def initialize(controller_name)
      super "Undefined controller #{controller_name}"
    end
  end
  
  # Thrown when neither the action nor a template exists for an action on a controller.
  class ActionNameError < NameError
    def initialize(controller, action)
      super "Undefined action #{action} for #{controller}"
    end
  end
  
  #
  # An Acoustic::Controller is very similar to it's Rails counterpart. Actions
  # are encapselated in methods. Views are automatically rendered for the action
  # if they exist.
  # 
  # For example:
  #
  #  class GuestBookController < Acoustic::Controller
  #    def index
  #      @guests = Guests.find(:all)
  #    end
  #    
  #    def create
  #      Guest.create!(params[:guest])
  #      redirect_to :index
  #    end
  #  end
  # 
  # In the example above, the <tt>index</tt> action retrieves the list of guests from
  # the database and stores it in an instance variable which can then be used
  # in the view to render the list.
  #
  # The second action, <tt>create</tt>, is used to create a new guest based on the
  # parameters passed to the action in the <tt>params</tt> hash.
  #
  # One key difference with Rails is that views are assumed to be in the same
  # directory as the file where the controller was defined.
  #
  class Controller
    
    # Called by Acoustic::Dispatcher to handle the request and response.
    def process(action, params, request, response)
      @_params, @_request, @_response = params, request, response
      
      response['Content-Type'] = "text/html"
      
      send(action) if respond_to?(action)
      
      unless rendered?
        template = template_for(action)
        if File.file?(template)
          render :template => template
        else
          if respond_to? action
            raise TemplateNotFound.new(self, action)
          else
            raise ActionNameError.new(self, action)
          end
        end
      end
    end
    
    # Perform a render for an action. This method can be called with one of the 
    # following keys:
    #
    # * <tt>:text</tt> - render a string of text instead of a template
    # * <tt>:template</tt> - render a template; the template path is relative to the file that the controller is defined in
    def render(options)
      case
      when options.has_key?(:text)
        response.body = options[:text]
      when options.has_key?(:template)
        template_filename = options[:template]
        template_string = IO.read(template_filename)
        view = View.new(self)
        template_engine = engine_for(template_string, :filename => template_filename)
        view.content = template_engine.render(view)
        if has_layout?
          layout_string = IO.read(layout)
          layout_engine = engine_for(layout_string, :filename => layout)
          response.body = layout_engine.render(view) do |*args|
            view.get_content_for(*args)
          end
        else
          response.body = view.content
        end
      else
        raise 'invalid options passed to render'
      end
      @_rendered = true
      response.body
    end
    
    def redirect_to(path)
      path = full_url_for(path)
      response['location'] = path
      response['status'] = "302 Found"
      render :text => %{
        <html>
          <head>
            <title>302 Found</title>
            <meta http-equiv="refresh" content="0;url=#{path}" />
          </head>
          <body>
            <script>window.location="#{path}"</script>
            <noscript>Redirecting to <a href="#{path}">#{path}</a></noscript>
          </body>
        </html>
      }.strip.gsub(/\s+/, ' ')
    end
    
    # Return the full URL for path based on the request URI.
    # TODO: handle HTTPS and default ports for other protocols correctly
    def full_url_for(path)
      path = full_path_for(path)
      uri = request.request_uri
      host = uri.scheme + "://" + uri.host
      port = uri.port
      host << ":#{port}" unless port == 80
      "#{host}#{path}"
    end
    
    # Return the full path for the relative path
    # TODO: support relative paths
    def full_path_for(path)
      path = "/#{path}" unless path[0..0] == '/'
      path
    end
    
    # Return the template for <tt>action</tt>.
    def template_for(action)
      name = self.class.name
      name = $1 if name =~ /^(.*?)Controller$/
      name = Inflector.underscore(name)
      absolute_template_filename_for("#{ name }_#{ action }.html.erb")
    end
    
    # Return the absolute filename for a relative template filename.
    def absolute_template_filename_for(relative_filename)
      File.expand_path(File.join(self.class.template_load_path, relative_filename))
    end
    
    def has_layout?
      File.exists?(layout)
    end
    
    def layout
      @layout ||= absolute_template_filename_for("layout.html.erb")
    end
    
    module ClassMethods
      
      # The filename where the class was defined. This is derived when the abstract
      # class is subclassed.
      attr_reader :filename
      
      def inherited(klass) #:nodoc:
        # determine the filename where the class was defined
        begin
          raise
        rescue => e
          line = e.backtrace[1]
          klass.instance_variable_set("@filename", $1) if line.match(/^(.*?):/)
        end
      end
      
      # Returns the directory where templates are loaded from. By default this
      # is the same directory where the file where the controller is defined is
      # located.
      def template_load_path
        @template_load_path ||= File.expand_path(File.dirname(self.filename))
      end
      
      # Convienence class method for creating a new controller and processing the
      # request and response. Calls Acoustic::Controller#process.
      def process(*args)
        new.process(*args)
      end
      
      # Returns the class of the controller that matches a symbol. For example,
      # if you passed :guest_book, it would return GuestBookController if it existed.
      # This method exists to allow the Acoustic::Dispatcher to to quickly map symbols
      # to controller classes.
      def from_symbol(symbol)
        name = Inflector.camelize("#{symbol}_controller")
        Inflector.constantize(name)
      rescue NameError
        raise Acoustic::ControllerNameError.new(name)
      end
      
    end
    extend ClassMethods
    
    protected
      
      # Returns the request object for the current action.
      def request
        @_request
      end
      
      # Returns the response object for the current action.
      def response
        @_response
      end
      
      # Returns the params passed to the curent action.
      def params
        @_params
      end
      
      def rendered?
        @_rendered == true
      end
    
    private
      
      # Create a new rendering engine for a template. Currently only supports
      # ERB, but will eventually have support for other engines.
      def engine_for(string, options = {}) #:nodoc:
        ERB::Engine.new(string, :filename => options[:filename])
      end
    
  end
end