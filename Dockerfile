FROM ruby:3.2.2

# Instala dependências básicas
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Cria diretório da app
WORKDIR /app

# Copia os arquivos
COPY . .

# Instala bundler e as gems
RUN gem install bundler && bundle install

# Expõe a porta
EXPOSE 3000

# Comando de inicialização
CMD ["bundle", "exec", "ruby", "config.ru", "-p", "3000", "-o", "0.0.0.0"]

