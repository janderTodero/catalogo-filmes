# app/controllers/dashboard/imports_controller.rb
class Dashboard::ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @import = Import.new
  end

  def create
    @import = current_user.imports.new(import_params)
    @import.status = :pending

    if @import.save
      MoviesImportJob.perform_later(@import.id)
      redirect_to dashboard_movies_path, notice: "Upload iniciado! Os filmes serão importados em breve."
    else
      render :new, alert: "Erro ao enviar o arquivo."
    end
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end
end
