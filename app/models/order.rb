class Order < ApplicationRecord
  has_many :orderitems, autosave: true

  validates_presence_of :orderitems
end
