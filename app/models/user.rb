class User < ApplicationRecord
  has_secure_password
  belongs_to :organisation

  has_many :reviews, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :onboarding_pets, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :images, dependent: :destroy

  enum role: { customer: 0, employee: 1, admin: 2 }

  scope :active, -> { where(active: true) }
  scope :customers, -> { where(role: :customer) }
  scope :employees, -> { where(role: :employee) }
  scope :admins, -> { where(role: :admin) }
  scope :employees_and_admins, -> { where(role: [:employee, :admin]) }

  default_scope { active }

  def archive
    self.update!(active: false)
  end

  def full_name
    [self.first_name, self.last_name].join(" ")
  end
end