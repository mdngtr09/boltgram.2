class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:show, :destroy]

  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 5).includes(:photos, :user, :likes).
      order("created_at desc")
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      if params[:images]
        params[:images].each do |img|
          # img é um objeto ActionDispatch::Http::UploadedFile, então use img diretamente
          @post.photos.create(image: img)  # Aqui, img é o próprio arquivo a ser salvo
        end
      end


      redirect_to posts_path
      flash[:notice] = "Saved ..."
    else
      flash[:alert] = "Something went wrong ..."
      redirect_to posts_path
    end
  end

  def show
    @photos = @post.photos
    @likes = @post.likes.includes(:user)
    @comment = Comment.new
    @is_liked = @post.is_liked(current_user)
    @is_bookmarked = @post.is_bookmarked(current_user)
  end

  def destroy
    if @post.user == current_user
      if @post.destroy
        flash[:notice] = "Post deleted!"
      else
        flash[:alert] = "Something went wrong ..."
      end
    else
      flash[:notice] = "You don't have permission to do that!"
    end
    redirect_to root_path
  end

  private

  def find_post
    @post = Post.find_by id: params[:id]

    return if @post
    flash[:danger] = "Post not exist!"
    redirect_to root_path
  end

  def post_params
    params.require(:post).permit :content
  end
end
