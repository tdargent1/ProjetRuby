class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :category_list, only: [:new, :edit]

  before_action :authenticate_user!, only: [:new, :create]

  # GET /posts
  def index
  @posts = Post.all
  end

  # GET /posts/1
  def show
    @comments = Comment.where(post_id: params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: 'Post created'
    else
      render :new
    end
  end

  # GET /posts/1/edit
  def edit
  end


  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post updated'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post destroyed"
  end

  private

  def set_post
     @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :status, category_ids: [])
  end

  def category_list
    @categories = Category.all
  end
end
