module Acoustic
  
  # 
  class UnresolvableUriError < StandardError;
  end
  
  # Thrown when the webserver cannot resolve a resource from a URL
  class NotFoundError < StandardError
    def initialize(uri)
      super "Resource not found for #{uri}"
    end
  end
  
  class TemplateNotFoundError < NameError
    def initialize(controller, action)
      super("Template not found for #{controller}##{action}")
    end
  end
  
  # Thrown when accoustic cannot resolve a URL to a controller
  class ControllerNameError < NameError
    def initialize(controller_name)
      super "Undefined controller #{controller_name}"
    end
  end
end