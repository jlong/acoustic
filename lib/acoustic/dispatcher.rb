require 'acoustic/url_mapper'
require 'acoustic/controller'

module Acoustic
  class Dispatcher
    
    def initialize(project_root, config, mapper = UrlMapper)
      @config = config
      @mapper = mapper.load(File.join(project_root, 'urls.rb'))
    end
    
    def service(request, response)
      params = @mapper.resolve_uri(request.request_uri)
      controller = controller_from_symbol(params[:controller])
      action = params[:action]
      controller.process(action, params, request, response)
    rescue Acoustic::UnresolvableUriError
      raise Acoustic::NotFoundError
    end
    
    private
      
      def controller_from_symbol(symbol)
        constantize(camelize("#{symbol}_controller"))
      end
      
      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end
      
      def constantize(camel_cased_word)
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?
        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end
    
  end
end