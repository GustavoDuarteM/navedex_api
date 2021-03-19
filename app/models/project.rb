class Project < ApplicationRecord
  belongs_to :user
  has_many :naver_project
  has_many :navers, through: :naver_project
end
