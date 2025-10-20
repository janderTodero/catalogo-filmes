# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.create!(
  email: 'teste@teste.com',
  password: '123456',
  name: 'Usuário Teste'
)

10.times do |i|
  user.movies.create!(
    title: "Filme #{i + 1}",
    synopsis: "Sinopse do filme #{i + 1}",
    release_year: 2020 + rand(0..4),
    duration: 90 + rand(0..90),
    director: "Diretor #{i + 1}"
  )
end
