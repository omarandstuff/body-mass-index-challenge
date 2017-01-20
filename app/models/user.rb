class User < ApplicationRecord
  has_secure_password
  has_many :records, class_name: 'MassIndexRecord', dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
