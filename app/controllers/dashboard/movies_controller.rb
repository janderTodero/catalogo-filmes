class Dashboard::MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [ :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @movies = current_user.movies.page(params[:page]).per(10)
    @import = Import.new
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = current_user.movies.new(movie_params)

    if @movie.save
      redirect_to movie_path(@movie), notice: "Filme cadastrado com sucesso!"
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

  def fetch_movie_data_ai
  title = params[:title]
  if title.blank?
    return render json: { error: "Título do filme é obrigatório." }, status: :unprocessable_entity
  end

  begin
    chat = RubyLLM.chat(provider: :gemini, model: "gemini-2.5-pro")
    prompt = "Me retorne apenas um JSON com as seguintes informações sobre o filme: #{title}. sinopse, ano_de_lancamento, duracao(em minutos), diretor."
    response = chat.ask(prompt)

    json_text = if response.content.is_a?(String)
                  response.content
    else
                  response.content.text
    end

    json_text.gsub!(/```json|```/, "")
    movie_data = JSON.parse(json_text) rescue nil

    if movie_data.nil?
      render json: { error: "Não foi possível interpretar a resposta da IA." }, status: :unprocessable_entity
    else
      render json: {
        success: true,
        movie: {
          synopsis: movie_data["sinopse"],
          release_year: movie_data["ano_de_lancamento"],
          duration: movie_data["tempo_de_duracao"] || movie_data["duracao"],
          director: movie_data["diretor"]
        }
      }
    end
  rescue => e
    render json: { error: "Erro ao se comunicar com o serviço de IA: #{e.message}" }, status: :internal_server_error
  end
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
