require 'swagger_helper'

RSpec.describe 'Projects API', type: :request do
  path '/api/projects' do
    get 'Lista todos os projetos do usuário autenticado' do
      tags 'Projects'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :tech, in: :query, type: :string, required: false, description: 'Nome da tecnologia'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Resultados por página'

      response '200', 'projetos listados' do
        let(:user) { create(:user) }
        let!(:projects) { create_list(:project, 3, user: user) }

        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        run_test!
      end
    end
  end

  path '/api/projects' do
    post 'Cria um novo projeto' do
      tags 'Projects'
      consumes 'multipart/form-data'
      security [bearerAuth: []]

      parameter name: :'project[title]', in: :formData, type: :string, required: true
      parameter name: :'project[description]', in: :formData, type: :string, required: true
      parameter name: :'project[image]', in: :formData, type: :file, required: false
      parameter name: :'project[tech_tags][]', in: :formData, type: :array, items: { type: :string }, required: false

      response '201', 'projeto criado com sucesso' do
        let(:user) { create(:user) }
        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        let(:'project[title]') { 'Portfólio Técnico' }
        let(:'project[description]') { 'Aplicação Rails API + React' }
        let(:'project[tech_tags][]') { ['Rails', 'React'] }
        let(:'project[image]') { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'sample.png'), 'image/png') }

        run_test!
      end

      response '401', 'não autenticado' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/projects/{id}' do
    patch 'Atualiza um projeto existente' do
      tags 'Projects'
      consumes 'multipart/form-data'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :'project[title]', in: :formData, type: :string, required: false
      parameter name: :'project[description]', in: :formData, type: :string, required: false
      parameter name: :'project[image]', in: :formData, type: :file, required: false
      parameter name: :'project[tech_tags][]', in: :formData, type: :array, items: { type: :string }, required: false

      response '200', 'projeto atualizado com sucesso' do
        let(:user) { create(:user) }
        let!(:project) { create(:project, user: user) }
        let(:id) { project.id }

        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        let(:'project[title]') { 'Projeto Atualizado' }
        let(:'project[description]') { 'Nova descrição' }
        let(:'project[tech_tags][]') { ['Redis', 'GraphQL'] }
        let(:'project[image]') { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'sample.png'), 'image/png') }

        run_test!
      end

      response '404', 'projeto não encontrado' do
        let(:user) { create(:user) }
        let(:id) { 'invalid' }
        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        run_test!
      end
    end
  end

  path '/api/projects/{id}' do
    delete 'Remove um projeto existente' do
      tags 'Projects'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :string, required: true

      response '204', 'projeto deletado com sucesso' do
        let(:user) { create(:user) }
        let!(:project) { create(:project, user: user) }
        let(:id) { project.id }

        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        run_test!
      end

      response '404', 'projeto não encontrado' do
        let(:user) { create(:user) }
        let(:id) { 'inexistente' }

        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        run_test!
      end
    end
  end
end
