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

    def accept_request
      user_action = UserAction.find(params[:user_action_id])

      film = Film.find(user_action.film_id)
      film.user_id = user_action.from_user_id
      film.save!

      user_action.accept!

      respond_to do |format|
        format.html { redirect_to edit_user_path, notice: "Tu as prêté #{film.titre} à #{User.find(user_action.from_user_id).name}" }
        format.json { head :no_content }
      end
    end

    def refuse_request
      user_action = UserAction.find(params[:user_action_id])
      user_action.refuse!
      
      respond_to do |format|
        format.html { redirect_to edit_user_path, notice: "Tu as refusé la demande de prêt de #{User.find(user_action.from_user_id).name}" }
        format.json { head :no_content }
      end
    end

    def follow
      Following.create(
        follower_id: params[:follower_id],
        followee_id: @user.id
      ).save!

      respond_to do |format|
        format.html { redirect_to edit_user_path(@user) }
        format.json { head :no_content }
      end
    end

    def unfollow
      f = Following.where(
        :follower_id => params[:follower_id],
        :followee_id => @user.id
      ).last
      
      f.delete

      respond_to do |format|
        format.html { redirect_to edit_user_path(@user) }
        format.json { head :no_content }
      end
    end
    
  
    private
  
    def set_user
       @user = User.find(params[:id])
    end
  end
  