class CommentsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    @comment = @movie.comments.new(comment_params)

    if user_signed_in?
      comment.user = current_user
      comment.author_name = current_user.name
    end
  end

  if @comment.save
      redirect_to movie_path(@movie), notice: "Comentário adicionado com sucesso."
  else
      redirect_to movie_path(@movie), alert: "Erro ao adicionar comentário."
  end
  private

  def comment_params
    params.require(:comment).permit(:content, :author_name)
  end
end
