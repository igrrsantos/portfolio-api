class Api::ProfileController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    render json: {
      message: "Autenticado com sucesso!",
      user: current_user
    }, status: :ok
  end
end
