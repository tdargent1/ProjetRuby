class PostsController < ApplicationController

    before_action :set_post, only: [:show, :edit, :update, :destroy]

    #GET /posts
    def index
        @posts = Post.all
    end

    #GET /posts/1
    def show
        @comments = Comment.where(post_id: params[:id])
    end

    #GET /posts/new
    def new 
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)
        if @post.save
            redirect_to @post, notice: "Post Created"
        else
            render :new
        end
    end

    def update
        if @post.update(post_params)
            redirect_to @post, notice: 'Post Updated'
        else
            render :edit
        end
    end
    

    def edit
    end

    def destroy
        @post.destroy
        redirect_to posts_path, notice: "Post Destroyed"
    end

    private

    def post_params
        params.require(:post).permit(:title, :content, :status)
    end

    def set_post
        @post = Post.find(params[:id])
    end
end