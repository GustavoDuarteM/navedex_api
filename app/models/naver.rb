class Naver < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :projects
  validates :name, :birthdate, :admission_date, :job_role, presence: true

  scope :filter_by_name, ->(name) do
    where('lower(name) like ?', "%#{name.strip.downcase}%")
  end
  scope :filter_by_job_role, ->(job_role) do
    where('lower(job_role) like ?', "%#{job_role.strip.downcase}%")
  end
  scope :filter_by_admission_date, ->(date) do
    where('admission_date <= ?', date.to_s) 
  end

end
