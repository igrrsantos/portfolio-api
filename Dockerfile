# Use a imagem oficial do Ruby
FROM ruby:3.2.2

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
RUN apt-get update && apt-get install -y postgresql-client awscli

# Crie e defina o diretório de trabalho
WORKDIR /app

# Copie o Gemfile e instale as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copie todo o projeto
COPY . .

# Adicione um script para executar migrações e iniciar o servidor
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Comando padrão (substitua se necessário)
# CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]