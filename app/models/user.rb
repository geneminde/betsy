class User < ApplicationRecord
  validates :uid, uniqueness: { scope: :provider }

  validates :username,
            presence: true,
            uniqueness: true
end
