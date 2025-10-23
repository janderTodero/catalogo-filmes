class Dashboard::MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [ :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @movies = current_user.movies.page(params[:page]).per(10)
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = current_user.movies.new(movie_params)

    if @movie.save
      redirect_to dashboard_movies_path, notice: "Filme cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to dashboard_movies_path, notice: "Filme atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to dashboard_movies_path, notice: "Filme excluído com sucesso!"
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def authorize_user!
    unless @movie.user == current_user
      redirect_to dashboard_movies_path, alert: "Você não está autorizado a realizar esta ação."
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :release_year, :duration, :director, :tag_list, :cover_image, category_ids: [])
  end
end
