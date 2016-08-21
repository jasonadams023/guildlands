class MarketOrder < ApplicationRecord
  belongs_to :hall_inventory
  belongs_to :item
end
