class Unit < ApplicationRecord
	include Helper

	belongs_to :guild_hall
	belongs_to :activity

	has_many :unit_inventories

	has_and_belongs_to_many :unit_abilities

	def set_spent_xp
	    self.spent_xp = 0
	end

	def set_costs
		self.hiring_cost = self.total_xp
		self.upkeep_cost = 10
	end

	def set_hp
	    self.max_hp = self.vitality * 10
	end

	def set_sp
	    self.max_sp = self.stamina * 10
	end

	def set_defenses
	    self.dodge = self.agility
	    self.resilience = 0
	    self.resist = self.intelligence
	end

	def full_heal
	    self.current_hp = self.max_hp
	    self.current_sp = self.max_sp
	end

	def set_effects
		self.effects = {}

		#unit abilities
			#activities
		activity_abilities = self.unit_abilities.select{|a| a.effects['activities'] != nil}
		activities = []
		activity_abilities.each do |ability|
			arr = ability.effects['activities'].split
			arr.each {|act| activities << act}
		end
		activities = activities.uniq

		activities_str = ''
		activities.each {|a| activities_str += a + ' '}

		self.effects['activities'] = activities_str
			#end of activities

			#equipment
		gear = self.unit_inventories.select{|inv| inv.equipped = true}
		gear.each do |equip|
			equip.hall_inventory.item.effects.each do |key, effect|
				if self.effects[key] == nil
					self.effects[key] = effect
				else
					if key == 'slot'
						self.effects[key] += " #{effect}"
					else
						self.effects[key] += effect
					end
				end
			end
		end
					#end of equipment
	end

	def total_xp_change(amount)
		max_xp = 10000
		if self.total_xp + amount < max_xp #max xp
			self.total_xp = max_xp
		elsif self.total_xp + amount < 0
			self.total_xp = 0
		else
			self.total_xp += amount
		end
	end

	def current_hp_change(amount)
		if self.current_hp + amount > self.max_hp
			self.current_hp = self.max_hp
		elsif self.current_hp + amount < 0
			self.current_hp = 0
		else
			self.current_hp += amount
		end
	end

	def current_sp_change(amount)
		if self.current_sp + amount > self.max_hp
			self.current_sp = self.max_hp
		elsif self.current_sp + amount < 0
			self.current_sp = 0
		else
			self.current_sp += amount
		end
	end

	def return_activities
		#effect specific activities
	    hall_activities = self.guild_hall.effects['activities'].split
	    if self.effects['activities'] != nil
	    	activities = self.effects['activities'].split
	    else
	    	activities = []
	    end
	    activity = []

	    hall_activities.each do |hall_act|
	    	activities.each do |unit_act|
	    		if hall_act == unit_act
					act_by_names = Activity.select {|a| a.name.include?(hall_act)}
					act_by_names.each do |i|
						activity << i
					end
				end
			end
	    end

	    #location specific activities
	    activities = Activity.select{|a| a.location_id == self.guild_hall.location_id}
	    activities.each do |a|
	      activity << a
	    end

	    #non specific activities
	    activities = Activity.select{|a| a.category == 'open'}
	    activities.each do |a|
	      activity << a
	    end

	    return activity
	end

	#New unit functions

	def custom_new
		set_spent_xp
		set_costs
		set_hp
		set_sp
		set_defenses
		full_heal
		self.activity = Activity.find(1)
		self.effects = {}
	end

	def self.new_hall(hall)
		unit = Unit.new
		unit.name = hall.guild.user.username
		unit.total_xp = 500
		unit.strength = 5
		unit.agility = 5
		unit.vitality = 5
		unit.stamina = 5
		unit.intelligence = 5
		unit.focus = 5
		unit.activity = Activity.find(1)
		unit.effects = {}
		unit.set_spent_xp
		unit.set_costs
		unit.set_hp
		unit.set_sp
		unit.set_defenses
		unit.full_heal

		unit.guild_hall_id = hall.id

		unit.save
		return unit
	end

	#On tick functions
	def crafting(items_string)
		parsed = items_string_parse(items_string)
		can_craft = true
		
		parsed.each do |item, amount|
			if amount < 0
				id = self.guild_hall.hall_inventories.find_index {|inv| inv.item_id == item.id}
				if id == nil
					can_craft = false
				elsif self.guild_hall.hall_inventories[id].available + amount < 0
					can_craft = false
				end
			end
		end

		if can_craft then self.guild_hall.tic_inventory(items_string) end
	end

	def activity_run
		if self.activity.effects['xp'] != nil then self.total_xp_change(self.activity.effects['xp'].to_i) end
		if self.activity.effects['hp'] != nil then self.current_hp_change(self.activity.effects['hp'].to_i) end
		if self.activity.effects['sp'] != nil then self.current_sp_change(self.activity.effects['sp'].to_i) end
		if self.activity.effects['money'] != nil then self.guild_hall.guild.money += self.activity.effects['money'].to_i end
		if self.activity.effects['inventory1'] != nil && self.activity.category != 'crafting' then self.guild_hall.tic_inventory(self.activity.effects['inventory1']) end
		if self.activity.category == 'crafting' then self.crafting(self.activity.effects['inventory1']) end

		self.activity = Activity.find(1)#set to idle

		self.save
		self.guild_hall.guild.save
	end
end