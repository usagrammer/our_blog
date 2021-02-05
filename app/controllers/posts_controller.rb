class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.valid? #valid?によって、@postが正しく保存されるものなのかどうかを判断している。保存されるようであれば保存しルートパスへ。保存できないものであれば、新規投稿ページに戻っている
      @post.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    if @post.valid? #valid?によって、@postが正しく更新されるものなのかどうかを判断している。更新されるものであれば詳細ページに戻り、更新できないものであれば、投稿編集ページに戻っている
      redirect_to post_path(@post.id)
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :image).merge(user_id: current_user.id)
  end
end
