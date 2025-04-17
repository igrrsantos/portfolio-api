# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # ou substitua por 'http://localhost:5173' em produção use domínio fixo

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: ['Authorization']
  end
end
