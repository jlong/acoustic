# mount "admin/", "admin/urls"
# mount "blog/", "blog/urls"
# mount "hello/", "hello/urls"

# This works until mount is implemented

require 'hello/controllers'
connect 'hello/:action', :controller => :hello

require 'blog/controllers'
require 'blog/models'
connect 'blog/:controller/:action'