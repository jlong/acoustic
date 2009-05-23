# mount "admin/", "admin/urls"
# mount "blog/", "blog/urls"
# mount "hello/", "hello/urls"

require 'hello/controllers'
connect '*', :controller => :hello, :action => :show