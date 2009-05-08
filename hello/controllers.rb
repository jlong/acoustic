class HelloController < Acoustic::Controller
  def show
    render :text => "Hello World!"
  end
end