class Naver < ApplicationRecord
  include CommonScopes
  belongs_to :user
  has_many :naver_project, dependent: :destroy
  has_many :projects, through: :naver_project

  validates :name, :birthdate, :admission_date, :job_role, presence: true

  scope :filter_by_job_role, ->(job_role) do
    where('lower(job_role) like ?', "%#{job_role.strip.downcase}%")
  end
  scope :filter_by_admission_date, ->(date) do
    where('admission_date <= ?', date.to_s) 
  end

end
