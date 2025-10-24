class MoviesImportJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    require "csv" unless defined?(CSV)   # garante que a constante exista
    import = Import.find(import_id)
    import.update(status: :processing)

    csv_data = import.file.download
    CSV.parse(csv_data, headers: true) do |row|
      puts row.inspect
      Movie.create!(
        title: row["title"],
        synopsis: row["synopsis"],
        release_year: row["release_year"],
        duration: row["duration"],
        director: row["director"],
        user_id: import.user_id
      )
    end

    import.update(status: :done)
  rescue => e
    import.update(status: :failed)
    Rails.logger.error("Erro ao importar CSV: #{e.message}")
  end
end