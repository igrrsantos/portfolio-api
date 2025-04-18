# Use imagem oficial do Ruby
FROM ruby:3.2.2

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Cria diretório do app
WORKDIR /app

# Copia arquivos
COPY . .

# Instala gems
RUN bundle install

# ✅ Cria e migra o banco automaticamente
RUN bundle exec rails db:create db:migrate

# Porta que o Railway usa
EXPOSE 8080

# Comando padrão de inicialização
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
