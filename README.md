# Catálogo de Filmes

Catálogo de filmes desenvolvido com Ruby on Rails. Este projeto oferece funcionalidades para gerenciar um catálogo de filmes, rotas com autenticação e sem autenticação, adicionar comentários nos filmes, autenticado ou anônimo, buscar e filtrar conteúdos, tags, paginação, upload de imagens e processamento em background.

## Sumário
- Repositório: https://github.com/janderTodero/catalogo-filmes
- Deploy: https://catalogo-filmes-tej3.onrender.com
- Ambiente de desenvolvimento usado: WSL (Ubuntu)
- Ruby: 3.4.7
- Banco: PostgreSQL
- Jobs: Sidekiq (ActiveJob adapter = :sidekiq)
- Testes: RSpec + factory_bot_rails
- Estilização: TailwindCSS

---

## Pré-requisitos (WSL / Ubuntu)
Antes de começar, confirme que no WSL você tem:
- Git
- rbenv ou rvm (para instalar Ruby)
- Ruby 3.4.x
- Bundler
- PostgreSQL (serviço rodando)
- Redis (para Sidekiq)
- build-essential e dependências nativas (libpq-dev, imagemagick/mini_magick se necessário)

Exemplo (Ubuntu / WSL):
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential libssl-dev libreadline-dev zlib1g-dev \
  libpq-dev postgresql postgresql-contrib redis-server curl git
```

Inicie serviços:
```bash
sudo service postgresql start
sudo service redis-server start
```

---

## Passo a passo para rodar localmente (WSL)
Copie e cole os comandos no terminal WSL (assumindo clone em ~/catalogo-filmes).

1. Clone o repositório
```bash
cd ~
git clone https://github.com/janderTodero/catalogo-filmes.git
cd catalogo-filmes
```

2. Instale Ruby (exemplo com rbenv) e Bundler
```bash
# instale rbenv / ruby-build se ainda não tiver
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# instale Ruby (ex.: 3.4.7)
rbenv install 3.4.7
rbenv local 3.4.7

gem install bundler
```

3. Instale gems do projeto
```bash
bundle install
```

4. Configure variáveis de ambiente (arquivo `.env` ou export)
Crie `.env` na raiz (não versionar com segredos reais):
```env
DATABASE_URL=postgres://seu_user:sua_senha@localhost:5432/catalogo_filmes_development
REDIS_URL=redis://localhost:6379/1
GEMINI_API_KEY=<sua_api>
SMTP_USER=<username:MailerSend>
SMTP_PASSWORD=<password>
SECRET_KEY_BASE=alguma_chave_segura
CLOUDINARY_URL=para_salvar_imagens_em_produção
```
(O projeto inclui `dotenv-rails` em development e irá carregar `.env` automaticamente.)

5. Prepare o banco de dados e dados iniciais
```bash
# script presente no projeto
bin/setup

# ou manualmente:
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed   # popula categorias, usuário exemplo e filmes
```

6. Inicie o servidor Rails (WSL → acessar do Windows)
Para permitir acesso do Windows ao Rails rodando no WSL, rode vinculando em 0.0.0.0:
```bash
./bin/dev 
ou bin/rails server -b 0.0.0.0 -p 3000
# acessível em http://localhost:3000 (em muitos setups WSL2)
```

---

## Executando Sidekiq (background jobs)
1. Verifique Redis rodando:
```bash
sudo service redis-server start
# ou use redis-server em foreground para debug
```

2. Inicie Sidekiq (na raiz do projeto, em outro terminal)
```bash
bundle exec sidekiq
```

- Se existir `config/sidekiq.yml`, inicie com `bundle exec sidekiq -C config/sidekiq.yml`.
- Sidekiq processará jobs como `MoviesImportJob` e entregas de e-mail (`deliver_later`).

---

## Importação em massa (CSV)
O projeto implementa importação via model `Import`, job `MoviesImportJob` e `ImportMailer`. Você pode subir o CSV pela interface (Dashboard → Imports) ou via console.

Formato esperado do CSV (cabeçalho que o job usa):
- title — título do filme (string) — obrigatório
- synopsis — sinopse (texto)
- release_year — ano de lançamento (inteiro)
- duration — duração em minutos (inteiro)
- director — nome(s) do(s) diretor(es) (string; múltiplos separados por vírgula)
- categories — categorias separadas por vírgula (ex.: "Ação, Ficção")
- tags — tags separadas por vírgula (ex.: "aventura,clássico")

Exemplo:
```csv
title,synopsis,release_year,duration,director,categories,tags
"Star Wars - Uma Nova Esperança","A princesa Leia é mantida refém pelo Império...",1977,121,"George Lucas","Ficção, Aventura","galáxia,espacial"
"Matrix","Um hacker descobre a verdade sobre a realidade...",1999,136,"Lana Wachowski,Lilly Wachowski","Ação, Ficção","virtual,realidade"
```

Observações:
- Na interface há um exemplo com cabeçalhos em português (`titulo,sinopse,...`), porém o job processador espera colunas em inglês. Para garantir processamento correto, use os cabeçalhos em inglês listados acima. Posso ajudar a adaptar o importador para aceitar alias em português, se preferir.
- `categories` e `tags` são listas separadas por vírgula; o importador cria/associa conforme necessário.
- Em caso de falhas o job acumula erros e o `ImportMailer` notifica o usuário (started/completed/failed).

Como enfileirar via console:
```bash
bin/rails console
# no console:
user = User.first
import = Import.create!(user: user)
import.file.attach(io: File.open("tmp/movies.csv"), filename: "movies.csv")
MoviesImportJob.perform_later(import.id)  # requer Sidekiq rodando
# ou para rodar de forma síncrona
MoviesImportJob.perform_now(import.id)
```

---

## Testes
O projeto usa RSpec, shoulda_matchers e factory_bot_rails. Executar:
```bash
bundle exec rspec
```
Executar um spec específico:
```bash
bundle exec rspec spec/jobs/movies_import_job_spec.rb
```

---

## Funcionalidades implementadas

### Área Pública

- Listagem de todos os filmes cadastrados, ordenados do mais novo para o mais antigo
- Paginação da listagem com até seis filmes por página: Kaminari + kaminari-tailwind
- Visualização dos detalhes de um filme: título, sinopse, ano de lançamento, duração e diretor
- Possibilidade de adicionar comentários anônimos, informando apenas um nome e o conteúdo do comentário
- Comentários exibidos do mais recente para o mais antigo
- Cadastro de novo usuário e recuperação de senha via email: Email enviado via MailerSend em produção

### Área Autenticada

- Autenticação: Devise
- Possibilidade do usuário fazer logout
- Usuário autenticado pode cadastrar novos filmes, editá-los e apagá-los
- O usuário só pode editar e apagar filmes criados por ele
- Usuário autenticado pode comentar com seu nome automaticamente vinculado ao comentário
- Possibilidade de editar perfil e alterar senha

### Opcionais

- Categorias de filmes: cadastrar e atribuir uma ou mais categorias aos filmes
- Busca de filmes por título, diretor e/ou ano de lançamento: Ransack
- Filtros por categoria, ano ou diretor: Ransack
- Tags: acts-as-taggable-on
- Upload/transformação de imagens: Active Storage + Cloudinary + image_processing / mini_magick (gems presentes)
- Internacionalização (I18n) com suporte a português e inglês
- Testes: RSpec, shoulda-matchers e factory_bot_rails

- Importação em massa via CSV: model `Import`, job `MoviesImportJob`, mailer `ImportMailer` e views. Processada em segundo plano com Sidekiq
    - Acompanhar o status da importação (em andamento, concluída ou com erros)
    - Receber notificação por e-mail quando o processo de importação for concluído: `ImportMailer` e visualização via letter_opener
    - OBS: Sidekiq não está rodando em produção devido a não ter versão free

- Buscar e preencher os dados do cadastro do filme por IA
    - Integração com LLM via `ruby_llm` (initializer lê GEMINI_API_KEY)
    - Preeche automaticamente os campos: sinopse, ano de lançamento, duração e diretor
    - Retorno de erros


## Contato / Autor
Repositório: https://github.com/janderTodero/catalogo-filmes
Autor: janderTodero