class ArticlesController < Acoustic::Controller
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.create(params)
  end
  
  def index
    @articles = Article.find(:all)
  end
  
  def show
    @article = Article.find(params[:id])
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    @article.attributes = params
    @article.save!
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
  end
  
end

class CommentsController < Acoustic::Controller
  def create
    params.delete(:action) # nasty
    params.delete(:controller) # nasty
    @comment = Comment.create(params) # clean up to use params[:comment]
    @_rendered = true # nasty
    response.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, '/blog/articles/show?id=' + params[:article_id])
  end
end