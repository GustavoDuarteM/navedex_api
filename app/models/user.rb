class User < ApplicationRecord
  has_secure_password
  has_many :projects
  has_many :navers
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
