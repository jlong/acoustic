require 'acoustic'

module Acoustic
  #
  # The Acoustic::Inflector module provides a number of helper methods for converting
  # strings to classes and vice versa.
  #
  module Inflector
    #
    # Much of the code here has been copied directly from Rails.
    #
    module Methods
      
      # Convert a CamelCasedWord to a lowercase word with underscores.
      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
      
      # Convert a lowercaseed and underscored word into a CamelCasedWord. The parameter
      # <tt>first_letter_in_uppercase</tt> defines whether or not the first letter should
      # be capitalized.
      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end
      
      # Take a CamelCasedWord, and convert it into a constant.
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
    extend Methods
  end
end