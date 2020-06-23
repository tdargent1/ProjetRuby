class FilmsController < ApplicationController
  before_action :set_film, only: [:show, :edit, :update, :destroy, :add]
  before_action :check_admin, except: [:index, :show, :add]

  # GET /films
  # GET /films.json
  def index
    @films = Film.all
  end

  # GET /films/1
  # GET /films/1.json
  def show
  end

  # GET /films/new
  def new
    @film = Film.new
  end

  # GET /films/1/edit
  def edit
  end

  # POST /films
  # POST /films.json
  def create
    @film = Film.new(film_params)

    respond_to do |format|
      if @film.save
        format.html { redirect_to @film, notice: t('film.successfully_created') }
        format.json { render :show, status: :created, location: @film }
      else
        format.html { render :new }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /films/1
  # PATCH/PUT /films/1.json
  def update
    respond_to do |format|
      if @film.update(film_params)
        format.html { redirect_to @film, notice: t('film.successfully_updated') }
        format.json { render :show, status: :ok, location: @film }
      else
        format.html { render :edit }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1
  # DELETE /films/1.json
  def destroy
    @film.destroy
    respond_to do |format|
      format.html { redirect_to films_url, notice: t('film.successfully_destroyed.') }
      format.json { head :no_content }
    end
  end

  def add

    film = Film.find params[:id]

    ua = UserAction.new(
      from_user_id: current_user.id,
      to_user_id: current_user.id,
      film_id: film.id
    )
    film.user_id = current_user.id
    film.save!

    ua.save!
    ua.accept!

    respond_to do |format|
      format.html { redirect_to @film, notice: t('film.added_to_collection') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_film
      @film = Film.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def film_params
      params.require(:film).permit(:titre, :realisateur, :timestamps)
    end

    def check_admin
      if !current_user || !current_user.has_role?(:admin)
        respond_to do |format|
          format.html { redirect_to '/', alert: t('page.insufficient_rights') }
          format.json { head :no_content }
        end
      end
    end
end
