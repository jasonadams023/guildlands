class HallInventory < ApplicationRecord
  belongs_to :guild_hall
  belongs_to :item
end
