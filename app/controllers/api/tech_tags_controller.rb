class Api::TechTagsController < ApplicationController
  before_action :authenticate_user!

  def index
    tags = TechTag.select(:id, :name).order(:name)
    render json: tags
  end
end
