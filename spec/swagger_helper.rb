# frozen_string_literal: true

require 'rails_helper'

# 🔧 CORREÇÃO para evitar erro de constante ausente
unless defined?(Rswag::Specs::Rails)
  module Rswag
    module Specs
      Rails = ::Rails
    end
  end
end

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Portfolio',
        version: 'v1',
        description: 'Documentação da API do portfólio técnico com autenticação JWT'
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        }
      },
      security: [ { bearerAuth: [] } ],
      paths: {}
    }
  }

  config.swagger_format = :yaml
end
