class MarketOrder < ApplicationRecord
  belongs_to :hall_inventory, dependent: :destroy
  belongs_to :item
end
