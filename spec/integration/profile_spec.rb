require 'swagger_helper'

RSpec.describe 'Profile API', type: :request do
  path '/api/profile' do
    get 'Retorna o usuário autenticado' do
      tags 'Profile'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'usuário autenticado' do
        let(:Authorization) { "Bearer #{get_token}" }

        run_test!
      end

      response '401', 'sem token' do
        run_test!
      end
    end
  end
end
