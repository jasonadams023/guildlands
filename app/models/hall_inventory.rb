class HallInventory < ApplicationRecord
  belongs_to :guild_hall, dependent: :destroy
  belongs_to :item

  has_many :market_orders, dependent: :destroy
end
