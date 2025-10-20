class MoviesController < ApplicationController
  def index
    @movies = Movie.page(params[:page]).per(6)
  end

  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments.order(created_at: :desc)
    @comment = Comment.new
  end
end
