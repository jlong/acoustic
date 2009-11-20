class HelloController < Acoustic::Controller
  def index
    render :text => "Hello World!"
  end
end