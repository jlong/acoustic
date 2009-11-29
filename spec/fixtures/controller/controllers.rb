class TestController < Acoustic::Controller
  def show
    @name = "World"
  end
  
  def no_template
    # no template is associated with this action
  end
end