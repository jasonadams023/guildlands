class Room < ApplicationRecord
	has_many :room_inventories
	has_many :guild_halls, through: :room_inventories
end
