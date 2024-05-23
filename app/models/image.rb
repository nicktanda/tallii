class Image < ApplicationRecord
  belongs_to :pet, optional: true
  belongs_to :product, optional: true
  belongs_to :category, optional: true
  has_one_attached :image

  validate :correct_image_type
  validate :image_size

  private

  def correct_image_type
    if image.attached? && !image.content_type.in?(%w(image/jpeg image/png))
      image.purge
      errors.add(:image, 'must be a JPEG or PNG')
    end
  end

  def image_size
    if image.attached? && (image.byte_size <= 1.kilobyte || image.byte_size >= 2.megabytes)
      image.purge
      errors.add(:image, 'File size must be between 1KB and 2MB')
    end
  end
end