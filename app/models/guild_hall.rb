class GuildHall < ApplicationRecord
  include Helper

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

  def set_effects
    self.effects = {}

      #Room Effects
    rooms = self.rooms.each do |room|
      room.effects.each do |key, effect|
        if key != 'activities' #handled in next section
          if self.effects[key] == nil
            self.effects[key] = effect
          else
            if key.include?('modifier')
              self.effects[key] = self.effects[key].to_f * effect.to_f
            else
              self.effects[key] = self.effects[key].to_i + effect.to_i
            end
          end
        end
      end
    end
      #end of room effects

    #enable activities
      #get activities that rooms enable
    rooms = self.rooms.select{|room| room.effects['activities'] != nil}
    room_activities = []
    rooms.each do |room|
      arr = room.effects['activities'].split
      arr.each {|act| room_activities << act }
    end
    room_activities = room_activities.uniq

      #get activities that units enable
    units = self.units.select{|unit| unit.effects['activities'] != nil}
    unit_activities = []
    units.each do |unit|
      arr = unit.effects['activities'].split
      arr.each {|act| unit_activities << act}
    end
    unit_activities = unit_activities.uniq

      #compare enabled activities
    hall_activities_str = ''
    room_activities.each do |room_act|
      if unit_activities.include?(room_act) then hall_activities_str += room_act + ' ' end
    end

    self.effects['activities'] = hall_activities_str
    #end of enable activities

      #get Guild Abilities
    self.guild.effects.each do |key, effect|
      if key != 'activities'
        if self.effects[key] == nil
          self.effects[key] = effect
        else
          if key.include?('modifier')
            self.effects[key] = self.effects[key].to_f * effect.to_f
          else
            self.effects[key] = self.effects[key].to_i + effect.to_i
          end
        end
      end
    end
      #end of Guild Abilities

      #location effects
    self.location.effects.each do |key, effect|
      if key != 'activities'
        if self.effects[key] == nil
          self.effects[key] = effect
        else
          if key.include?('modifier')
            self.effects[key] = self.effects[key].to_f * effect.to_f
          else
            self.effects[key] = self.effects[key].to_i + effect.to_i
          end
        end
      end
    end
      #end of location effects

    #unit_limit
    self.set_unit_limit

    #other effects
  end

  def add_inventory(item, amount)
    if !(self.items.include?(item))
      self.items << item
      id = self.hall_inventories.find_index{|i| item.id == i.item_id}
      inventory = self.hall_inventories[id]
      inventory.total = 0
      inventory.available = 0
      inventory.selling = 0
      inventory.using = 0
      inventory.save
    else
      id = self.hall_inventories.find_index{|i| item.id == i.item_id}
      inventory = self.hall_inventories[id]
    end

    inventory.total += amount
    inventory.available += amount

    inventory.save
  end

  def tic_inventory(items_string, modifier)
    if modifier != nil then modifier = modifier.to_f else modifier = 1 end
    parsed = items_string_parse(items_string)

    parsed.each do |item, amount|
      if amount > 0
        self.add_inventory(item, (amount * modifier).to_i)
      else
        self.add_inventory(item, amount)
      end
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
    hall.set_effects
    hall.save
    return hall
  end
end