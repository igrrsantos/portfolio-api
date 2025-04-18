class Api::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:public_index]

  def index
    if current_user
      projects = current_user.projects.includes(:tech_tags).map do |project|
        project.as_json(only: [:id, :title, :description, :created_at, :updated_at]).merge(
          image_url: project.image.attached? ? url_for(project.image) : nil,
          tech_tags: project.tech_tag_names
        )
      end
      render json: projects
    else
      render json: { error: 'Não autenticado' }, status: :unauthorized
    end
  end

  def public_index
    projects = Project.includes(:tech_tags, image_attachment: :blob).all

    render json: projects.map { |project|
      {
        id: project.id,
        title: project.title,
        description: project.description,
        image_url: project.image.attached? ? url_for(project.image) : nil,
        tech_tags: project.tech_tags.map(&:name)
      }
    }
  end

  def show
    project = current_user.projects.includes(:tech_tags).find_by(id: params[:id])

    if project
      render json: project.as_json(only: [:id, :title, :description, :created_at, :updated_at]).merge(
        image_url: project.image.attached? ? url_for(project.image) : nil,
        tech_tags: project.tech_tags.pluck(:name)
      )
    else
      render json: { error: 'Projeto não encontrado' }, status: :not_found
    end
  end

  def create
    project = current_user.projects.new(project_params)
    if project.save
      attach_tech_tags(project)
      render json: project_with_tags(project), status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    project = current_user.projects.find_by(id: params[:id])

    if project
      if params[:project][:tech_tags]
        tag_names = params[:project].delete(:tech_tags)
        tags = TechTag.where(name: tag_names)
        project.tech_tags = tags
      end

      project.update(project_params)
      render json: project
    else
      render json: { error: 'Projeto não encontrado' }, status: :not_found
    end
  end

  def destroy
    project = current_user.projects.find_by(id: params[:id])
    if project
      project.destroy
      render json: { message: 'Projeto excluído com sucesso' }, status: :ok
    else
      render json: { error: 'Projeto não encontrado' }, status: :not_found
    end
  end

  private

  def attach_tech_tags(project)
    return unless params[:project][:tech_tags]

    tag_names = params[:project][:tech_tags]
    tag_names.each do |name|
      tag = TechTag.find_or_create_by(name: name)
      project.tech_tags << tag unless project.tech_tags.include?(tag)
    end
  end

  def project_with_tags(project)
    project.as_json.merge({
      tech_tags: project.tech_tags.pluck(:name),
      image_url: project.image.attached? ? url_for(project.image) : nil
    })
  end

  def set_project
    @project = current_user.projects.find_by(id: params[:id])
    return head :not_found unless @project
  end

  def project_params
    params.require(:project).permit(:title, :description, :image, tech_tag_ids: [])
  end

  def project_response(project)
    image_url = project.image.attached? ? url_for(project.image) : nil

    {
      id: project.id,
      title: project.title,
      description: project.description,
      image_url: image_url
    }
  end
end
