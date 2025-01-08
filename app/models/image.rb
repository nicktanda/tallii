class Image < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :pet, optional: true
  belongs_to :onboarding_pet, optional: true
  belongs_to :product, optional: true
  belongs_to :category, optional: true
  belongs_to :groom, optional: true
  belongs_to :temporary_groom, optional: true
  has_one_attached :image

  validate :correct_image_type

  private

  def correct_image_type
    if image.attached? && !image.content_type.in?(%w(image/jpeg image/png image/gif image/webp))
      image.purge
      errors.add(:image, 'must be a JPEG, PNG, GIF or WEBP')
    end
  end
end