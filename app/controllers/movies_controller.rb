class MoviesController < ApplicationController
  def index
    @movies = Movie.page(params[:page]).per(6)
    @movies = @movies.by_category(params[:category]) if params[:category].present?
    @movies = @movies.by_year(params[:year]) if params[:year].present?
    @movies = @movies.by_director(params[:director]) if params[:director].present?

    if params[:search].present?
    search = params[:search]
    @movies = @movies.where(
      "title ILIKE :s OR director ILIKE :s OR CAST(release_year AS TEXT) ILIKE :s",
      s: "%#{search}%"
    )
  end
  end

  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments.order(created_at: :desc)
    @comment = Comment.new
  end
end
