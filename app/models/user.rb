class User < ApplicationRecord
  has_secure_password

  belongs_to :organisation
end