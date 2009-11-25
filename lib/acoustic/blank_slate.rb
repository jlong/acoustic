module Acoustic
  class BlankSlate
    instance_methods.each { |m| undef_method m unless m =~ /^(__|instance_)/ }
  end
end