class User < ApplicationRecord
  has_secure_password
  has_many :projects
  has_many :navers
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
end
