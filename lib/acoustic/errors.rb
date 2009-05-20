module Acoustic
  class Error < StandardError; end
  class UnresolvableUriError < Error; end
  class NotFoundError < Error; end
end