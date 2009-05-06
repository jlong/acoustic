class ArticlesController < AcousticPostsController
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.create(params)
  end
  
  def index
    @articles = Article.find(:all)
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
  
def 