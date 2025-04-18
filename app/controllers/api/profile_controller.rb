class Api::ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: {
      message: "Autenticado com sucesso!",
      user: current_user
    }, status: :ok
  end
end
