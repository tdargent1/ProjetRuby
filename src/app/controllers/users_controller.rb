class UsersController < ApplicationController

  before_action :set_user, except: [:index, :new, :create]
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy, :respond_request]

  # GET /users
  def index
    @users = User.all
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
    redirect_to users_url, notice: t('user.have_been_deleted')
  end

  def request_film

    current_user_action = UserAction.where(:film_id => params[:film_id],
                                           :to_user_id => params[:to_user_id],
                                           :from_user_id => params[:from_user_id],
                                           :status => "waiting")

    if current_user_action.empty?

      user_action = UserAction.new

      user_action.from_user_id = params[:from_user_id]
      user_action.to_user_id = params[:to_user_id]
      user_action.film_id = params[:film_id]
      user_action.status = "waiting"

      user_action.save!

      respond_to do |format|
        format.html { redirect_to films_path, notice: t(
            'asked_to_an_user_a_movie',
            user_name: User.find(user_action.to_user_id).name,
            film_title: Film.find(user_action.film_id).titre
        ) }
        format.json { head :no_content }
      end

    else

      respond_to do |format|
        format.html { redirect_to films_path, alert: t(
            'already_asked_movie',
            user_name: User.find(params[:to_user_id]).name
        ) }
        format.json { head :no_content }
      end

    end
  end

  def accept_request
    user_action = UserAction.find(params[:user_action_id])

    film = Film.find(user_action.film_id)
    film.user_id = user_action.from_user_id
    film.save!

    user_action.accept!

    others_user_action = UserAction.where(:film_id => user_action.film_id, :to_user_id => user_action.to_user_id, :status => "waiting")
    others_user_action.each { |ua| ua.refuse! }

    respond_to do |format|
      format.html { redirect_to edit_user_path, notice: t(
          'lent_movie',
          film_title: film.titre,
          user_name: User.find(user_action.from_user_id).name
      ) }
      format.json { head :no_content }
    end
  end

  def refuse_request
    user_action = UserAction.find(params[:user_action_id])
    user_action.refuse!

    respond_to do |format|
      format.html { redirect_to edit_user_path, notice: t(
          'refused_lent_movie',
          user_name: User.find(user_action.from_user_id).name
      ) }
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
    