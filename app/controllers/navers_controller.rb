class NaversController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_navers, only: [:index]
  before_action :set_projects, only: [:store, :update]
  before_action :query_navers_params, only: [:index]
  before_action :set_naver, only: [:show, :update, :delete]
  before_action :not_found_naver, only: [:show, :delete, :update], if: -> { @naver.blank? }

  def index
    render json: NaverSerializer.new(@navers).serializable_hash
  end

  def show
    render json: NaverWithRelationsSerializer.new(@naver).serializable_hash
  end

  def store
    @naver = current_user.navers.new(naver_params.except(:projects).merge({ projects: @projects }))
    if valid_project_ids? && @naver.save
      render json: NaverWithRelationsSerializer.new(@naver).serializable_hash, status: :created
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
      render json: NaverWithRelationsSerializer.new(@naver).serializable_hash
    else
      message = ''
      message = @naver.errors.full_messages.join(' ,') unless @naver.valid?

      if params[:projects].present? && @projects != params[:projects].length
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

  def not_found_naver
    render json: nil, status: :not_found
  end

  def naver_params
    params.permit(
      :name,
      :birthdate,
      :job_role,
      :admission_date,
      projects: []
    )
  end

  def query_navers_params
    params.permit(:name, :job_role, :admission_date)
  end

  def set_navers
    if !query_navers_params.empty? &&
       query_navers_params.to_h.reduce(false){ |result, params| params[1].present? || result }

      @navers = current_user.navers.filter_by_name(params[:name]) if params[:name].present?

      if params[:job_role].present?
        @navers = @navers.filter_by_job_role(params[:job_role]) if @navers
        @navers ||= current_user.navers.filter_by_job_role(params[:job_role])
      end

      if params[:admission_date].present?
        date = DateTime.parse(params[:admission_date])
        @navers = @navers.filter_by_admission_date(date) if @navers
        @navers ||= current_user.navers.filter_by_admission_date(date)
      end
    else
      @navers = current_user.navers
    end
  end

  def set_naver
    @naver = current_user.navers.find(params[:id]) rescue nil
  end

  def valid_project_ids?
    projects_length = params[:projects].length rescue 0
    @projects.length == projects_length
  end

  def set_projects
    @projects = current_user.projects.where(id: params[:projects])
  end
end
