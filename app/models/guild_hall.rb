class GuildHall < ApplicationRecord
  belongs_to :guild
  belongs_to :location

  has_many :room_inventories, dependent: :destroy
  has_many :rooms, through: :room_inventories
  has_many :units
  has_many :hall_inventories
  has_many :items, through: :hall_inventories

  store_accessor :effects #can include unit limit, bonuses, etc.

  #Methods
	def set_unit_limit()
		self.unit_limit = 0
		arr = self.rooms.select{|room| room.effects['unit_limit'] != nil}
		arr.each do |room|
			self.unit_limit += room.effects['unit_limit'].to_i
		end
	end

  def add_inventory(item, amount)
    if !(self.items.include?(item))
      self.items << item
      id = self.hall_inventories.find_index{|i| item.id == i.item_id}
      inventory = self.hall_inventories[id]
      inventory.total = 0
      inventory.available = 0
      inventory.selling = 0
      inventory.save
    else
      id = self.hall_inventories.find_index{|i| item.id == i.item_id}
      inventory = self.hall_inventories[id]
    end

    inventory.total += amount
    inventory.available += amount

    inventory.save
  end

  def tic_inventory(items_string)
    strings = items_string.split

    strings.each do |string|
      arr = string.split('_')
      amount = arr[0].to_i
      item_str = arr[1].split('-').join(' ')
      item = Item.select{|i| i.name == item_str}
      self.add_inventory(item[0], amount)
    end
    self.save
  end

  #new Guild Hall functions
  def self.new_guild(guild)
    hall = GuildHall.new
    hall.name = guild.user.username + "'s First Guild Hall"
    hall.size = 10
    hall.location_id = 1
    hall.effects = {}
    hall.rooms << Room.find(3)#Dorm, size 3, +4 unit_limit
    hall.set_unit_limit

    hall.guild_id = guild.id

    hall.save
    unit = Unit.new_hall(hall)

    unit.save
    hall.save
    return hall
  end
end