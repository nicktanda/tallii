class Category < ApplicationRecord
  belongs_to :organisation
  has_many :images, dependent: :destroy
end