class UsersController < ApplicationController
  
    before_action :set_user, except: [:index, :new, :create]
    before_action :authenticate_user!, only: [:show, :edit, :update, :destroy, :respond_request]
  
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
        @actions = @user.user_actions
    end
  
  
    # PATCH/PUT /users/1
    def update
    end
  
    # DELETE /posts/1
    def destroy
      @user.destroy
      redirect_to users_url, notice: "Account destroyed"
    end

    def respond_request
      user_action = UserAction.find(params[:user_action_id])
      
      if params[:accepted] == true
        film = Film.find(user_action.film_id)
        film.user_id = user_action.from_user_id
        film.save!

        user_action.accept!
      else
        user_action.refuse!
      end
      redirect_to edit_user_path + "#mes-actions"
    end
    
  
    private
  
    def set_user
       @user = User.find(params[:id])
    end
  end
  