class MassIndexRecord < ApplicationRecord
  belongs_to :user

  validates_numericality_of :body_mass_index
  validates :body_mass_index, presence: true
  validates :user, presence: true
end
