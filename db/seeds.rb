# Limpa o banco
Movie.destroy_all
Category.destroy_all
User.destroy_all

# Cria usuário
user = User.create!(name: "Jander", email: "jander@email.com", password: "123456")

category_names = [

  "Ação", "Comédia", "Drama", "Ficção Científica", "Terror",
  "Suspense", "Fantasia", "Aventura", "Romance", "Animação", "Crime",
  "Documentário", "Biografia", "Musical", "Western", "Guerra",
  "Thriller", "Mistério", "Histórico", "Familiar", "Comédia Romântica",
  "Super-heróis", "Anime", "Cult", "Indie", "Esportes"
]

categories = category_names.map { |name| Category.create!(name: name) }.index_by(&:name)


movies = [
  {
    title: "Star Wars - Uma Nova Esperança",
    synopsis: "A princesa Leia é mantida refém pelas forças imperiais comandadas por Darth Vader. Luke Skywalker e Han Solo precisam resgatá-la e restaurar a liberdade na galáxia.",
    release_year: 1977,
    duration: 121,
    director: "George Lucas",
    category_names: [ "Aventura", "Ficção Científica", "Fantasia" ],
    tags: [ "jedi", "espacial", "épico" ]
  },
  {
    title: "O Senhor dos Anéis: A Sociedade do Anel",
    synopsis: "Um hobbit é encarregado de destruir um anel poderoso antes que ele caia nas mãos do Senhor do Escuro.",
    release_year: 2001,
    duration: 178,
    director: "Peter Jackson",
    category_names: [ "Aventura", "Fantasia" ],
    tags: [ "anel", "épico", "fantasia" ]
  },
  {
    title: "Titanic",
    synopsis: "Um artista pobre e uma jovem rica se conhecem e se apaixonam a bordo do Titanic, um navio condenado a um trágico destino.",
    release_year: 1997,
    duration: 195,
    director: "James Cameron",
    category_names: [ "Drama", "Romance" ],
    tags: [ "navio", "romance", "trágico" ]
  },
  {
    title: "Interestelar",
    synopsis: "Um grupo de astronautas viaja através de um buraco de minhoca em busca de um novo lar para a humanidade.",
    release_year: 2014,
    duration: 169,
    director: "Christopher Nolan",
    category_names: [ "Ficção Científica", "Drama" ],
    tags: [ "espaço", "buraco de minhoca", "humanidade" ]
  },
  {
    title: "O Poderoso Chefão",
    synopsis: "A história da família Corleone, uma das mais poderosas máfias dos Estados Unidos.",
    release_year: 1972,
    duration: 175,
    director: "Francis Ford Coppola",
    category_names: [ "Crime", "Drama" ],
    tags: [ "máfia", "família", "crime" ]
  },
  {
    title: "Homem de Ferro",
    synopsis: "Tony Stark, um bilionário inventor, constrói uma armadura de alta tecnologia para combater o mal após ser sequestrado.",
    release_year: 2008,
    duration: 126,
    director: "Jon Favreau",
    category_names: [ "Ação", "Ficção Científica" ],
    tags: [ "herói", "armadura", "tecnologia" ]
  },
  {
    title: "Vingadores: Ultimato",
    synopsis: "Após Thanos eliminar metade da vida no universo, os Vingadores se unem para desfazer o estrago e restaurar o equilíbrio.",
    release_year: 2019,
    duration: 181,
    director: "Anthony e Joe Russo",
    category_names: [ "Ação", "Aventura", "Ficção Científica" ],
    tags: [ "heróis", "universo", "thanos" ]
  },
  {
    title: "Coringa",
    synopsis: "Arthur Fleck é um comediante fracassado que se transforma no lendário vilão Coringa após uma série de eventos trágicos.",
    release_year: 2019,
    duration: 122,
    director: "Todd Phillips",
    category_names: [ "Drama", "Crime" ],
    tags: [ "vilão", "psicopata", "comédia" ]
  },
  {
    title: "Toy Story",
    synopsis: "Os brinquedos de Andy ganham vida quando ele não está por perto. Woody, o cowboy, sente ciúmes quando Buzz Lightyear chega.",
    release_year: 1995,
    duration: 81,
    director: "John Lasseter",
    category_names: [ "Animação", "Comédia", "Aventura" ],
    tags: [ "brinquedos", "amigos", "aventura" ]
  },
  {
    title: "Invocação do Mal",
    synopsis: "Os investigadores paranormais Ed e Lorraine Warren ajudam uma família aterrorizada por uma presença sombria em sua casa.",
    release_year: 2013,
    duration: 112,
    director: "James Wan",
    category_names: [ "Terror", "Suspense" ],
    tags: [ "fantasma", "investigação", "terror" ]
  }
]

movies.each do |movie_data|
  movie = Movie.create!(
    title: movie_data[:title],
    synopsis: movie_data[:synopsis],
    release_year: movie_data[:release_year],
    duration: movie_data[:duration],
    director: movie_data[:director],
    user: user
  )

  movie.categories = movie_data[:category_names].map { |name| categories[name] }.compact
  movie.tag_list.add(*movie_data[:tags])
  movie.save!
end

puts "✅ Seed completo executado: #{Movie.count} filmes e #{Category.count} categorias criadas."
