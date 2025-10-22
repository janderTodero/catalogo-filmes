# Pega o primeiro usuário ou cria um se não existir
user = User.first || User.create!(name: "Jander", email: "jander@email.com", password: "123456")

# Transforma as categorias existentes em um hash para facilitar a associação
categories = Category.all.index_by(&:name)
# Exemplo: {"Ação"=>#<Category id:1,...>, "Comédia"=>#<Category id:2,...>}

movies = [
  {
    title: "Star Wars - Uma Nova Esperança",
    synopsis: "A princesa Leia é mantida refém pelas forças imperiais comandadas por Darth Vader. Luke Skywalker e Han Solo precisam resgatá-la e restaurar a liberdade na galáxia.",
    release_year: 1977,
    duration: 121,
    director: "George Lucas",
    category_names: ["Aventura", "Ficção Científica", "Fantasia"]
  },
  {
    title: "O Senhor dos Anéis: A Sociedade do Anel",
    synopsis: "Um hobbit é encarregado de destruir um anel poderoso antes que ele caia nas mãos do Senhor do Escuro.",
    release_year: 2001,
    duration: 178,
    director: "Peter Jackson",
    category_names: ["Aventura", "Fantasia"]
  },
  {
    title: "Titanic",
    synopsis: "Um artista pobre e uma jovem rica se conhecem e se apaixonam a bordo do Titanic, um navio condenado a um trágico destino.",
    release_year: 1997,
    duration: 195,
    director: "James Cameron",
    category_names: ["Drama", "Romance"]
  },
  {
    title: "Interestelar",
    synopsis: "Um grupo de astronautas viaja através de um buraco de minhoca em busca de um novo lar para a humanidade.",
    release_year: 2014,
    duration: 169,
    director: "Christopher Nolan",
    category_names: ["Ficção Científica", "Drama"]
  },
  {
    title: "O Poderoso Chefão",
    synopsis: "A história da família Corleone, uma das mais poderosas máfias dos Estados Unidos.",
    release_year: 1972,
    duration: 175,
    director: "Francis Ford Coppola",
    category_names: ["Crime", "Drama"]
  },
  {
    title: "Homem de Ferro",
    synopsis: "Tony Stark, um bilionário inventor, constrói uma armadura de alta tecnologia para combater o mal após ser sequestrado.",
    release_year: 2008,
    duration: 126,
    director: "Jon Favreau",
    category_names: ["Ação", "Ficção Científica"]
  },
  {
    title: "Vingadores: Ultimato",
    synopsis: "Após Thanos eliminar metade da vida no universo, os Vingadores se unem para desfazer o estrago e restaurar o equilíbrio.",
    release_year: 2019,
    duration: 181,
    director: "Anthony e Joe Russo",
    category_names: ["Ação", "Aventura", "Ficção Científica"]
  },
  {
    title: "Coringa",
    synopsis: "Arthur Fleck é um comediante fracassado que se transforma no lendário vilão Coringa após uma série de eventos trágicos.",
    release_year: 2019,
    duration: 122,
    director: "Todd Phillips",
    category_names: ["Drama", "Crime"]
  },
  {
    title: "Toy Story",
    synopsis: "Os brinquedos de Andy ganham vida quando ele não está por perto. Woody, o cowboy, sente ciúmes quando Buzz Lightyear chega.",
    release_year: 1995,
    duration: 81,
    director: "John Lasseter",
    category_names: ["Animação", "Comédia", "Aventura"]
  },
  {
    title: "Invocação do Mal",
    synopsis: "Os investigadores paranormais Ed e Lorraine Warren ajudam uma família aterrorizada por uma presença sombria em sua casa.",
    release_year: 2013,
    duration: 112,
    director: "James Wan",
    category_names: ["Terror", "Suspense"]
  }
]

movies.each do |movie_data|
  movie = Movie.find_or_create_by!(
    title: movie_data[:title],
    synopsis: movie_data[:synopsis],
    release_year: movie_data[:release_year],
    duration: movie_data[:duration],
    director: movie_data[:director],
    user: user
  )

  # associa categorias já existentes
  movie.categories = movie_data[:category_names].map { |name| categories[name] }.compact
  movie.save!
end
