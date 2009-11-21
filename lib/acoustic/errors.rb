module Acoustic
  class UnresolvableUriError < StandardError;
  end
  
  class NotFoundError < StandardError
    def initialize(uri)
      super "Resource not found for #{uri}"
    end
  end
  
  class ControllerNameError < NameError
    def initialize(controller_name)
      super "Undefined controller #{controller_name}"
    end
  end
end