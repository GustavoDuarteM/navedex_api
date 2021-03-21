class NaversController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_navers, only: [:index]
  before_action :filter_navers_params, only: [:index]
  before_action :filter_navers, only: [:index], unless: -> { filter_navers_params.empty? }
  before_action :set_projects, only: [:store, :update]
  before_action :set_naver, only: [:show, :update, :delete]
  before_action :not_found, only: [:show, :delete, :update], if: -> { @naver.blank? }

  def index
    render json: NaverSerializer.new(@navers).serializable_hash
  end

  def show
    render json: NaverWithRelationsSerializer.new(@naver, { include: [:projects] }).serializable_hash
  end

  def store
    @naver = current_user.navers.new(naver_params.except(:projects).merge({ projects: @projects }))
    if valid_project_ids? && @naver.save
      render json: NaverWithRelationsSerializer.new(@naver, { include: [:projects] }).serializable_hash, status: :created
    else
      message = @naver.errors.full_messages.join(' ,')
      if params[:projects].present? && !valid_project_ids?
        missing_projects_ids = (params[:projects] - @projects.pluck(:id)).join(', ')
        message += ', ' if message.present?
        message += "No project(s) were found with these id(s): #{missing_projects_ids}"
      end

      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def update
    if valid_project_ids? && @naver.update(naver_params.except(:projects).merge({ projects: @projects }))
      render json: NaverWithRelationsSerializer.new(@naver, { include: [:projects] }).serializable_hash
    else
      message = @naver.errors.full_messages.join(' ,')
      if params[:projects].present? && valid_project_ids?
        missing_projects_ids = (params[:projects] - @projects.pluck(:id)).join(', ')
        message += ', ' if message.present?
        message += "No project(s) were found with these id(s): #{missing_projects_ids}"
      end

      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def delete
    if @naver.delete
      render json: nil, status: :ok
    else
      render json: { error: @naver.errors.full_messages.join(' ,') }, status: :unprocessable_entity
    end
  end

  private

  def naver_params
    params.permit(
      :name,
      :birthdate,
      :job_role,
      :admission_date,
      projects: []
    )
  end

  def filter_navers_params
    params.permit(:name, :job_role, :admission_date)
  end

  def set_navers
    @navers = current_user.navers
  end

  def set_naver
    @naver = current_user.navers.find(params[:id]) rescue nil
  end
  
  def set_projects
    @projects = current_user.projects.where(id: params[:projects])
  end

  def filter_navers
    @navers = @navers.filter_by_name(params[:name]) if params[:name].present?
    @navers = @navers.filter_by_job_role(params[:job_role]) if params[:job_role].present?
    @navers = @navers.filter_by_admission_date(DateTime.parse(params[:admission_date])) if params[:admission_date].present?
  end


  def valid_project_ids?
    projects_length = params[:projects].length rescue 0
    @projects.length == projects_length
  end

end
