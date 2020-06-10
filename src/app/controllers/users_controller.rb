class UsersController < ApplicationController
  
    before_action :set_user, only: [:show, :update, :destroy, :edit]
    before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
  
    # GET /users
    def index
    end
  
    # GET /users/1
    def show
    end
  
    def new
    end
  
    def create
    end
  
    # GET /users/1/edit
    def edit

    end
  
  
    # PATCH/PUT /users/1
    def update
      if @user.update(post_params)
        redirect_to @user, notice: 'Profil updated'
      else
        render :edit
      end
    end
  
    # DELETE /posts/1
    def destroy
      @user.destroy
      redirect_to users_url, notice: "Account destroyed"
    end
  
    private
  
    def set_user
       @user = User.find(params[:id])
    end
  end
  