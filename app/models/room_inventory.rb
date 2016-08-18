class RoomInventory < ApplicationRecord
  belongs_to :guild_hall
  belongs_to :room
end
