require 'swagger_helper'

RSpec.describe 'Profile API', type: :request do
  path '/api/profile' do
    get 'Retorna o usuário autenticado' do
      tags 'Profile'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'usuário autenticado' do
        let!(:user) { create(:user) }
        let(:Authorization) do
          payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
          secret = ENV['JWT_SECRET_KEY'] || Rails.application.credentials.secret_key_base
          token = JWT.encode(payload, secret, 'HS256')
          "Bearer #{token}"
        end


        run_test!
      end

      response '401', 'sem token' do
        run_test!
      end
    end
  end
end
