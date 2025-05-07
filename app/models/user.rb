class User < ApplicationRecord
  has_secure_password
  belongs_to :organisation, optional: true

  has_many :reviews, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :onboarding_pets, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :grooms, foreign_key: 'employee_id'
  has_many :daycare_visits, foreign_key: 'employee_id'
  has_many :temporary_grooms, foreign_key: 'employee_id'
  has_many :temporary_daycare_visits, foreign_key: 'employee_id'

  enum :role, { customer: 0, employee: 1, admin: 2 }, default: :customer

  scope :active, -> { where(active: true) }
  scope :customers, -> { where(role: :customer) }
  scope :employees, -> { where(role: :employee) }
  scope :admins, -> { where(role: :admin) }
  scope :employees_and_admins, -> { where(role: [:employee, :admin]) }

  def archive
    self.update!(active: false)
  end

  def full_name
    [self.first_name, self.last_name].join(" ")
  end

  def self.colour_code_options
    {
      new_customer: "New Customer",
      referral: "Referral",
      staff_discount: "Staff Discount",
      senior_discount: "Seniors Discount",
      military_discount: "Military Discount",
      do_not_book: "Do Not Book",
      helicopter: "Helicopter/High Maintenance Client"
    }
  end

  def self.colours
    {
      new_customer: "bg-emerald-400",
      referral: "bg-teal-700",
      staff_discount: "bg-teal-950",
      senior_discount: "bg-violet-700",
      military_discount: "bg-amber-500",
      do_not_book: "bg-red-700",
      helicopter: "bg-purple-600"
    }
  end
end