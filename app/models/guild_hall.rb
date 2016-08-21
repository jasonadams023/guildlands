class GuildHall < ApplicationRecord
  belongs_to :guild
  belongs_to :location

  has_many :room_inventories, dependent: :destroy
  has_many :rooms, through: :room_inventories
  has_many :units
  has_many :hall_inventories
  has_many :items, through: :hall_inventories

  store_accessor :effects #can include unit limit, bonuses, etc.
end
