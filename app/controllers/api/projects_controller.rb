class Api::ProjectsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    projects = current_user.projects

    if params[:tech].present?
      projects = projects.joins(:tech_tags).where(tech_tags: { name: params[:tech] }).distinct
    end

    # Paginação padrão
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    paginated = projects.paginate(page: page, per_page: per_page)

    render json: {
      current_page: paginated.current_page,
      total_pages: paginated.total_pages,
      total_entries: paginated.total_entries,
      projects: paginated.map { |p| project_with_tags(p) }
    }
  end


  def show
    render json: project.as_json.merge({
      image_url: project.image.attached? ? url_for(project.image) : nil
    })
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
    if @project.update(project_params)
      render json: @project
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    head :no_content
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
    # binding.pry
    params.require(:project).permit(:title, :description, :tech_stack, :image)
  end
end
