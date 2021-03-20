class Project < ApplicationRecord
  include CommonScopes
  belongs_to :user
  has_many :naver_project, dependent: :destroy
  has_many :navers, through: :naver_project
  validates :name, presence: true, uniqueness: true
end
