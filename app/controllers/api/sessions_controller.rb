class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      secret = Rails.application.credentials.secret_key_base
      token = generate_token(user.id, secret)

      render json: {
        token: token,
        user: user.as_json(only: [:id, :email, :name]) # Ajuste os campos conforme necessário
      }, status: :ok
    else
      render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
    end
  end

  def destroy
    # Implementação de logout se necessário
    head :no_content
  end

  def validate_token
    head :ok # Retorna 200 se o token for válido
  end

  private

  def generate_token(user_id, secret)
    payload = {
      user_id: user_id,
      exp: 24.hours.from_now.to_i # Token expira em 24 horas
    }
    JWT.encode(payload, secret, 'HS256')
  end
end