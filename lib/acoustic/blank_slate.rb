module Acoustic #:nodoc:
  class BlankSlate
    # undefine all instance methods that do not begin with "__" or "instance"
    instance_methods.each { |m| undef_method m unless m =~ /^(__|instance_)/ }
  end
end