class Session < ApplicationRecord
  belongs_to :user

  validates :token, presence: true
  validates :token, uniqueness: true
  validates :token, format: { with: /\A[a-zA-Z0-9\-_=]+?\.[a-zA-Z0-9\-_=]+?\.([a-zA-Z0-9\-_=]+){1,}\z/ }
  validates :user, presence: true


  def activate!
    update_attribute :active, true
  end
end
