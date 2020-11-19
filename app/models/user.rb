class User < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :order_items, through: :products, dependent: :destroy
  has_many :categories, through: :products

  validates :uid,
            presence: true,
            uniqueness: { scope: :provider }

  validates :username, :email,
            presence: true,
            uniqueness: true

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = 'github'
    user.username = auth_hash['info']['name']
    user.email = auth_hash['info']['email']
    return user
  end

end
