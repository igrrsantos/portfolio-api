class Api::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  def create
    user = User.new(user_params)

    if user.save
      token = jwt_encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :name)
  end

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['JWT_SECRET_KEY'] || 'your_secret_key', 'HS256')
  end
end