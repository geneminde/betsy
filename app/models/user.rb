class User < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :order_items, through: :products, dependent: :destroy
  has_many :categories, through: :products
  has_many :orders
  has_many :reviews, through: :products, dependent: :destroy

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
    user.username = auth_hash[:info][:name] || auth_hash[:info][:nickname]
    user.email = auth_hash[:info][:email]
    return user
  end

  def check_own_product(product)
    user = self
    return user.products.include?(product)
  end
end
