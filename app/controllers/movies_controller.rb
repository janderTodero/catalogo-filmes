class MoviesController < ApplicationController
  def index
    @movies = Movie.page(params[:page]).per(6)
    @movies = @movies.by_category(params[:category]) if params[:category].present?
    @movies = @movies.by_year(params[:year]) if params[:year].present?
    @movies = @movies.by_director(params[:director]) if params[:director].present?

    if params[:search].present?
    search = params[:search]
    # Busca em título, diretor, release_year e tags
    @movies = @movies
      .left_joins(:tags) # faz join com tags
      .where(
        "movies.title ILIKE :s OR movies.director ILIKE :s OR CAST(movies.release_year AS TEXT) ILIKE :s OR tags.name ILIKE :s",
        s: "%#{search}%"
      )
      .distinct # evita duplicados por causa do join
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments.order(created_at: :desc)
    @comment = Comment.new
  end

end
