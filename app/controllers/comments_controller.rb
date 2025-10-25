class CommentsController < ApplicationController
  before_action :set_movie
  before_action :set_comment, only: [ :destroy ]
  before_action :authorize_comment!, only: [ :destroy ]

  def create
    @comment = @movie.comments.new(comment_params)

    if user_signed_in?
      @comment.user = current_user
      @comment.author_name = current_user.name
    end

    if @comment.save
      redirect_to movie_path(@movie), notice: t("comments.create.success")
    else
      redirect_to movie_path(@movie), alert: t("comments.create.error")
    end
  end

  def destroy
    @comment.destroy
    redirect_to movie_path(@movie), notice: t("comments.destroy.success")
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_comment
    @comment = @movie.comments.find(params[:id])
  end

  def authorize_comment!
    unless current_user == @comment.user
      redirect_to movie_path(@movie), alert: t("comments.unauthorized")
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :author_name)
  end
end
