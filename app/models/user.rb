class User < ApplicationRecord
  has_secure_password
  belongs_to :organisation, optional: true
  
  # Custom phone validation using phonelib
  validate :phone_number_validity, if: -> { phone.present? }

  # Normalize phone numbers before saving
  before_save :normalize_phone_numbers

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
  
  def formatted_phone
    return unless phone.present?
    parsed = Phonelib.parse(phone)
    parsed.valid? ? parsed.international : phone
  end
  
  def phone_with_country_code=(value)
    self.phone = value
  end
  
  def country_code=(code)
    if phone.present? && code.present?
      # Prepend the country code to the phone number
      phone_with_code = "+#{code}#{phone.gsub(/^\+?\d+/, '')}"
      parsed = Phonelib.parse(phone_with_code)
      self.phone = parsed.full_e164 if parsed.valid?
    end
  end
  
  private

  def normalize_phone_numbers
    # Strip all non-numeric characters from phone numbers
    self.phone = phone.gsub(/\D/, '') if phone.present?
    self.additional_user_phone = additional_user_phone.gsub(/\D/, '') if additional_user_phone.present?
  end

  def phone_number_validity
    parsed = Phonelib.parse(phone)
    unless parsed.possible?
      errors.add(:phone, "is not a valid phone number")
    end
  end
end