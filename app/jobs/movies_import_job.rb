class MoviesImportJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    require "csv" unless defined?(CSV)
    import = Import.find(import_id)

    begin
      Rails.logger.info "Importação ##{import.id} iniciada pelo usuário #{import.user.email}"

      import.update!(status: :processing)
      ImportMailer.started(import).deliver_later

      csv_data = import.file.download
      total_rows = CSV.parse(csv_data, headers: true).size
      processed = 0
      successes = []
      failures = []

      CSV.parse(csv_data, headers: true).each_with_index do |row, index|
        begin
          movie = Movie.create!(
            title: row["title"],
            synopsis: row["synopsis"],
            release_year: row["release_year"],
            duration: row["duration"],
            director: row["director"],
            user_id: import.user_id
          )

          if row["categories"].present?
              row["categories"].split(",").map(&:strip).each do |category_name|
              category = Category.find_or_create_by!(name: category_name)
              movie.categories << category unless movie.categories.include?(category)
            end
          end
          successes << movie.title
          processed += 1
          Rails.logger.info "Importação ##{import.id}: #{processed}/#{total_rows} filmes importados com sucesso"
        rescue => e
          failures << { row: index + 2, title: row["title"], error: e.message }
          Rails.logger.warn "Falha na importação da linha #{index + 2}: #{e.message}"
        end
      end

      import.update!(status: :done)
      Rails.logger.info "Importação ##{import.id} concluída: #{successes.size} filmes importados, #{failures.size} falhas"

      ImportMailer.completed(import, successes, failures).deliver_later

    rescue => e
      import.update(status: :failed)
      Rails.logger.error "Erro na importação ##{import.id}: #{e.message}\n#{e.backtrace.join("\n")}"
      ImportMailer.failed(import, e.message).deliver_later
    end
  end
end
