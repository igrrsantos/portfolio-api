FROM ruby:3.2.2

# Instala dependências básicas
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Cria diretório da app
WORKDIR /app

# Copia os arquivos
COPY . .

# Instala bundler e as gems
RUN gem install bundler && bundle install

# Prepara o banco
RUN bundle exec rake db:migrate || true

# Expõe a porta
EXPOSE 3000

# Comando de inicialização
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
