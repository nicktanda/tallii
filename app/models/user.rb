class User < ApplicationRecord
  has_secure_password
  belongs_to :organisation

  has_many :reviews, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :onboarding_pets, dependent: :destroy
  has_many :orders, dependent: :destroy

  scope :active, -> { where(active: true) }

  default_scope { active }

  def archive
    self.update!(active: false)
  end
end