class ProjectsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_projects, only: [:index]
  before_action :set_navers, only: [:store, :update]
  before_action :query_projects_params, only: [:index]
  before_action :set_project, only: [:show, :update, :delete]
  before_action :not_found, only: [:show, :delete, :update], if: -> { @project.blank? }

  def index
    render json: ProjectSerializer.new(@projects).serializable_hash
  end

  def show
    render json: ProjectWithRelationsSerializer.new(@project, { include: [:navers] }).serializable_hash
  end

  def store
    @project = current_user.projects.new(projects_params.except(:navers).merge({ navers: @navers }))
    if valid_navers_ids? && @project.save
      render json: ProjectWithRelationsSerializer.new(@project, { include: [:navers] }).serializable_hash, status: :created
    else
      message = @project.errors.full_messages.join(' ,')
      if params[:naver].present? && !valid_navers_ids?
        missing_navers_ids = (params[:navers] - @naver.pluck(:id)).join(', ')
        message += ', ' if message.present?
        message += "No navers(s) were found with these id(s): #{missing_navers_ids}"
      end

      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def update
    if valid_navers_ids? && @project.update(projects_params.except(:navers).merge({ navers: @navers }))
      render json: ProjectWithRelationsSerializer.new(@project, { include: [:navers] }).serializable_hash
    else
      message = @project.errors.full_messages.join(' ,') 

      if params[:naver].present? && valid_navers_ids?
        missing_navers_ids = (params[:navers] - @naver.pluck(:id)).join(', ')
        message += ', ' if message.present?
        message += "No navers(s) were found with these id(s): #{missing_navers_ids}"
      end

      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def delete
    if @project.delete
      render json: nil, status: :ok
    else
      render json: { error: @project.errors.full_messages.join(' ,') }, status: :unprocessable_entity
    end
  end

  private

  def query_projects_params
    params.permit(:name)
  end

  def projects_params
    params.permit(:name, navers: [])
  end

  def set_projects
    unless query_projects_params.empty?
      @projects = current_user.projects.filter_by_name(params[:name]) rescue nil
    end
    @projects ||= current_user.projects
  end

  def set_project
    @project = current_user.projects.find(params[:id]) rescue nil
  end

  def set_navers
    @navers = current_user.navers.where(id: params[:navers])
  end

  def valid_navers_ids?
    navers_length = params[:navers].length rescue 0
    @navers.length == navers_length
  end
end
