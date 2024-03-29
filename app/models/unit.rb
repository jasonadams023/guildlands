class Unit < ApplicationRecord
	include Helper

	belongs_to :guild_hall
	belongs_to :activity

	has_many :unit_inventories

	has_and_belongs_to_many :unit_abilities

	def self.find_by_guild (guild)
		where(guild_hall_id: GuildHall.where("guild_id = ?", guild.id).ids)
	end

	def custom_update(compare_unit)
		results = []

		if ((compare_unit.strength != nil && compare_unit.strength != self.strength) ||
				(compare_unit.agility != nil && compare_unit.agility != self.agility) ||
				(compare_unit.vitality != nil && compare_unit.vitality != self.vitality) ||
				(compare_unit.stamina != nil && compare_unit.stamina != self.stamina) ||
				(compare_unit.intelligence != nil && compare_unit.intelligence != self.intelligence) ||
				(compare_unit.focus != nil && compare_unit.focus != self.focus))

			results << {train: train(compare_unit)}
		end

		if compare_unit.name != nil && compare_unit.name != self.name
			results << {name: set_name(compare_unit.name)}
		end

		if compare_unit.guild_hall_id != nil && compare_unit.guild_hall_id != self.guild_hall_id
			results << {hall: set_hall(compare_unit.guild_hall_id)}
		end

		if compare_unit.activity_id != nil && compare_unit.activity_id != self.activity_id
			results << {activity: set_activity(compare_unit.activity_id)}
		end

		if compare_unit.total_xp != nil && compare_unit.total_xp != self.total_xp
			results <<{total_xp: set_total_xp(compare_unit.total_xp)}
		end

		if ((compare_unit.current_hp != nil && compare_unit.current_hp != self.current_hp) ||
			(compare_unit.current_sp != nil && compare_unit.current_sp != self.current_sp))
			results << {current_stats: set_current_stats(compare_unit)}
		end

		success = true

		results.each do |result|
			if result != "Success."
				if success == true
					response = result
					success = false
				else
					response += " " + result
				end
			end
		end

		if success == true
			response = "Unit Updated."
		end

		return response
	end

	def set_current_stats (compare_unit)
		result = ""

		if compare_unit.current_hp != nil && compare_unit.current_hp != self.current_hp
			if self.max_hp >= compare_unit.current_hp
				self.current_hp = compare_unit.current_hp
			else
				result = "Exceeds maximum hp."
			end
		end

		if compare_unit.current_sp != nil && compare_unit.current_sp != self.current_sp
			if self.max_sp >= compare_unit.current_sp
				self.current_sp = compare_unit.current_sp
			elsif result != ""
				result += " Exceeds maximum sp."
			else
				result = "Exceeds maximum sp."
			end
		end

		if result == ""
			if self.save
				result = "Success."
			else
				result = "Failed to update current stats."
			end
		end

		return result
	end

	def set_total_xp(new_total)
		self.total_xp = new_total

		if self.save
			return "Success."
		else
			return "Failed to change total xp."
		end
	end

	def set_activity (activity_id)
		activity = Activity.find(activity_id)

		if return_activities.include?(activity)
			self.activity = activity

			if self.save
				return "Success."
			else
				return "Failed to change activity."
			end
		else
			return "That activity is not available."
		end
	end

	def set_hall (hall_id)
		hall = GuildHall.find(hall_id)

		if hall.guild == self.guild_hall.guild
			if hall.units.length < hall.unit_limit
				hall.units << self

				if self.save && hall.save
					return "Success."
				else
					return "Failed to change Guild Hall."
				end
			else
				return "That Guild Hall cannot hold any more units."
			end
		else
			if hall.units.length < hall.unit_limit
				if hall.guild.money >= self.hiring_cost
					hall.units << self
					hall.guild.money -= unit.hiring_cost
					if self.save && hall.save && hall.guild.save
						return "Success."
					else
						return "Failed to purchase unit."
					end
				else
					return "Guild does not have enough money to hire this unit."
				end
			else
				return "That Guild Hall cannot hold any more units."
			end
		end
	end

	def set_name (name)
		self.name = name

		if self.save
			return "Success."
		else
			return "Failed to change name."
		end
	end

	def train (compare_unit)
		guild = self.guild_hall.guild
		cost = 0
		previous_discount = self.calc_xp_discount

		if compare_unit.strength != nil
			if compare_unit.strength > self.strength
				cost += compare_unit.calc_xp_per_stat(compare_unit.strength) - self.calc_xp_per_stat(self.strength)
				self.strength = compare_unit.strength
			end
		end
		if compare_unit.agility != nil
			if compare_unit.agility > self.agility
				cost += compare_unit.calc_xp_per_stat(compare_unit.agility) - self.calc_xp_per_stat(self.agility)
				self.agility = compare_unit.agility
			end
		end
		if compare_unit.vitality != nil
			if compare_unit.vitality > self.vitality
				cost += compare_unit.calc_xp_per_stat(compare_unit.vitality) - self.calc_xp_per_stat(self.vitality)
				self.vitality = compare_unit.vitality
			end
		end
		if compare_unit.stamina != nil
			if compare_unit.stamina > self.stamina
				cost += compare_unit.calc_xp_per_stat(compare_unit.stamina) - self.calc_xp_per_stat(self.stamina)
				self.stamina = compare_unit.stamina
			end
		end
		if compare_unit.intelligence != nil
			if compare_unit.intelligence > self.intelligence
				cost += compare_unit.calc_xp_per_stat(compare_unit.intelligence) - self.calc_xp_per_stat(self.intelligence)
				self.intelligence = compare_unit.intelligence
			end
		end
		if compare_unit.focus != nil
			if compare_unit.focus > self.focus
				cost += compare_unit.calc_xp_per_stat(compare_unit.focus) - self.calc_xp_per_stat(self.focus)
				self.focus = compare_unit.focus
			end
		end

		discount = self.calc_xp_discount - previous_discount
		cost -= discount

		if discount < 0 then discount = 0 end
		test_xp = self.calc_spent_xp

		if test_xp <= self.total_xp
			if test_xp > self.spent_xp then cost = test_xp - self.spent_xp else cost = 0 end

			if guild.money >= cost
				guild.money -= cost

				self.set_effects
				self.spent_xp = test_xp

				if self.save && guild.save
					return "Success."
				else
					return "Failed to train."
				end
			else
				return "Guild does not have enough money to train this unit."
			end
		else
			return "Spent xp would exceed total xp."
		end
	end

	def calc_xp_per_stat(stat)
		low_stat_cost = 15
		mid_stat_cost = 30
		high_stat_cost = 50

		if stat < 11
	    	return stat * low_stat_cost
	    elsif stat >10 && stat < 16
	    	return ((stat - 10) * mid_stat_cost) + 150
	    else
	    	return ((stat - 15) * high_stat_cost) + 300
	    end
	end

	def calc_xp_discount
		max_free_stats = 30
		free_stats = 0

		if self.strength <= 10 then free_stats += self.strength else free_stats += 10 end
		if self.agility <= 10 then free_stats += self.agility else free_stats += 10 end
		if self.vitality <= 10 then free_stats += self.vitality else free_stats += 10 end
		if self.stamina <= 10 then free_stats += self.stamina else free_stats += 10 end
		if self.intelligence <= 10 then free_stats += self.intelligence else free_stats += 10 end
		if self.focus <= 10 then free_stats += self.focus else free_stats += 10 end

		if free_stats <= max_free_stats then return free_stats * 15 else return max_free_stats * 15 end
	end

	def calc_spent_xp
	    xp = 0

	    self.unit_abilities.each do |ability|
	    	xp += ability.xp_cost
	    end

	    xp += calc_xp_per_stat(self.strength)
	    xp += calc_xp_per_stat(self.agility)
	    xp += calc_xp_per_stat(self.vitality)
	    xp += calc_xp_per_stat(self.stamina)
	    xp += calc_xp_per_stat(self.intelligence)
	    xp += calc_xp_per_stat(self.focus)

	    xp -= calc_xp_discount

	    return xp
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
		self.unit_abilities.each do |ability|
			ability.effects.each do |key, effect|
				if key != 'activities' #handled in activities section
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
			#end of unit abilities

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
		gear = self.unit_inventories.select{|inv| inv.equipped == true}
		gear.each do |equip|
			equip.hall_inventory.item.effects.each do |key, effect|
				if self.effects[key] == nil
					self.effects[key] = effect
				else
					if key == 'slot'
						self.effects[key] += " #{effect}"
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
			#end of equipment

			#Guild Hall
		if self.guild_hall != nil
			hall = self.guild_hall
			hall.effects.each do |key, effect|
				if key != 'activities'
					if self.effects[key] == nil
						self.effects[key] = effect
					else
						if key.include?('modifier')
				          self.effects[key] = self.effects[key] * effect
				        else
				          self.effects[key] += effect
				        end
					end
				end
			end
		end
			#end of guild hall
	end

	def strength_effect
		if self.effects['strength'] != nil
			return self.effects['strength'].to_i
		else
			return 0
		end
	end

	def strength_sum
		if self.effects['strength'] != nil
			sum = self.effects['strength'].to_i + self.strength
		else
			sum = self.strength
		end

		if self.effects['strength_modifier'] != nil
			sum = (sum * self.effects['strength_modifier'].to_f).to_i
		end

		if sum < 1 then sum = 1 end

		return sum
	end

	def agility_effect
		if self.effects['agility'] != nil
			return self.effects['agility'].to_i
		else
			return 0
		end
	end

	def agility_sum
		if self.effects['agility'] != nil
			sum = self.effects['agility'].to_i + self.agility
		else
			sum = self.agility
		end

		if self.effects['agility_modifier'] != nil
			sum = (sum * self.effects['agility_modifier'].to_f).to_i
		end

		if sum < 1 then sum = 1 end
		
		return sum
	end

	def vitality_effect
		if self.effects['vitality'] != nil
			return self.effects['vitality'].to_i
		else
			return 0
		end
	end

	def vitality_sum
		if self.effects['vitality'] != nil
			sum = self.effects['vitality'].to_i + self.vitality
		else
			sum = self.vitality
		end

		if self.effects['vitality_modifier'] != nil
			sum = (sum * self.effects['vitality_modifier'].to_f).to_i
		end

		if sum < 1 then sum = 1 end
		
		return sum
	end

	def stamina_effect
		if self.effects['stamina'] != nil
			return self.effects['stamina'].to_i
		else
			return 0
		end
	end

	def stamina_sum
		if self.effects['stamina'] != nil
			sum = self.effects['stamina'].to_i + self.stamina
		else
			sum = self.stamina
		end

		if self.effects['stamina_modifier'] != nil
			sum = (sum * self.effects['stamina_modifier'].to_f).to_i
		end

		if sum < 1 then sum = 1 end
		
		return sum
	end

	def intelligence_effect
		if self.effects['intelligence'] != nil
			return self.effects['intelligence'].to_i
		else
			return 0
		end
	end

	def intelligence_sum
		if self.effects['intelligence'] != nil
			sum = self.effects['intelligence'].to_i + self.intelligence
		else
			sum = self.intelligence
		end

		if self.effects['intelligence_modifier'] != nil
			sum = (sum * self.effects['intelligence_modifier'].to_f).to_i
		end

		if sum < 1 then sum = 1 end
		
		return sum
	end

	def focus_effect
		if self.effects['focus'] != nil
			return self.effects['focus'].to_i
		else
			return 0
		end
	end

	def focus_sum
		if self.effects['focus'] != nil
			sum = self.effects['focus'].to_i + self.focus
		else
			sum = self.focus
		end

		if self.effects['focus_modifier'] != nil
			sum = (sum * self.effects['focus_modifier'].to_f).to_i
		end

		if sum < 1 then sum = 1 end
		
		return sum
	end

	def dodge_sum
		if self.effects['dodge'] != nil
			sum = self.effects['dodge'].to_i + self.dodge
		else
			sum = self.dodge
		end

		if self.effects['dodge_modifier'] != nil
			sum = (sum * self.effects['dodge_modifier'].to_f).to_i
		end

		if sum < 0 then sum = 0 end

		return sum
	end

	def resilience_sum
		if self.effects['resilience'] != nil
			sum = self.effects['resilience'].to_i + self.resilience
		else
			sum = self.resilience
		end

		if self.effects['resilience_modifier'] != nil
			sum = (sum * self.effects['resilience_modifier'].to_f).to_i
		end

		if sum < 0 then sum = 0 end

		return sum
	end

	def resist_sum
		if self.effects['resist'] != nil
			sum = self.effects['resist'].to_i + self.resist
		else
			sum = self.resist
		end

		if self.effects['resist_modifier'] != nil
			sum = (sum * self.effects['resist_modifier'].to_f).to_i
		end

		if sum < 0 then sum = 0 end

		return sum
	end

	def upkeep_sum
		if self.effects['upkeep'] != nil
			sum = self.effects[:upkeep].to_i + self.upkeep
			if sum < 1 then sum = 1 end
		else
			sum = self.upkeep
		end

		if self.effects['upkeep_modifier'] != nil
			sum = (sum * self.effects['upkeep_modifier'].to_f).to_i
		end
		
		return sum
	end

	def total_xp_change(amount)
		max_xp = 3000
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
		self.spent_xp = self.calc_spent_xp
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
		unit.spent_xp = unit.calc_spent_xp
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

		if can_craft
			self.guild_hall.tic_inventory(items_string, self.effects['crafting_modifier'])
		else
			log = Log.my_new
			log.turn = OnTickJob.turn
			log.guild = self.guild_hall.guild
			log.data[:unit] = self.name
			log.message = "#{log.data[:unit]}: Could not finish #{self.activity.name} due to insufficient materials."
		end
	end

	def on_tick
		#Upkeep
		if self.guild_hall.guild.money >= self.upkeep_cost
			self.guild_hall.guild.money -= self.upkeep_cost

			#Activities
			if self.activity.effects['hp'].to_i < 0 && self.current_hp < 1
				log = Log.my_new
				log.turn = OnTickJob.turn
				log.guild = self.guild_hall.guild
				log.data[:unit] = self.name
				log.message = "#{log.data[:unit]}: Could not perform task #{self.activity.name} due to low hp."
			else
				if self.activity.effects['sp'].to_i < 0 && self.current_sp < 1
					log = Log.my_new
					log.turn = OnTickJob.turn
					log.guild = self.guild_hall.guild
					log.data[:unit] = self.name
					log.message = "#{log.data[:unit]}: Could not perform task #{self.activity.name} due to low sp."
				else
					if self.activity.effects['money'].to_i < 0 && self.guild_hall.guild.money < self.activity.effects['money']
						log = Log.my_new
						log.turn = OnTickJob.turn
						log.guild = self.guild_hall.guild
						log.data[:unit] = self.name
						log.message = "#{log.data[:unit]}: Could not perform task #{self.activity.name} due to low money in guild."
					else
						if self.activity.effects['reputation'] != nil then self.guild_hall.guild.reputation_change (self.activity.effects['reputation'].to_i) end
						if self.activity.effects['xp'] != nil then self.total_xp_change(self.activity.effects['xp'].to_i) end
						if self.activity.effects['hp'] != nil then self.current_hp_change(self.activity.effects['hp'].to_i) end
						if self.activity.effects['sp'] != nil then self.current_sp_change(self.activity.effects['sp'].to_i) end
						if self.activity.effects['money'] != nil then self.guild_hall.guild.money_change(self.activity.effects['money'].to_i) end
						if self.activity.effects['inventory1'] != nil && self.activity.category != 'crafting' then self.guild_hall.tic_inventory(self.activity.effects['inventory1'], self.effects['gather_modifier']) end
						if self.activity.category == 'crafting' then self.crafting(self.activity.effects['inventory1']) end
					end
				end
			end
		else
			log = Log.my_new
			log.turn = OnTickJob.turn
			log.guild = self.guild_hall.guild
			log.data[:unit] = self.name
			log.message = "#{log.data[:unit]}: Not enough money to pay for upkeep."
		end

		self.activity = Activity.find(1)#set to idle
		#end of Activities

		#Self
		if self.effects['xp'] != nil then self.total_xp_change(self.effects['xp'].to_i) end
		if self.effects['hp'] != nil then self.current_hp_change(self.effects['hp'].to_i) end
		if self.effects['sp'] != nil then self.current_sp_change(self.effects['sp'].to_i) end
		#end of Self

		# #Guild Hall
		# if self.guild_hall.effects['xp'] != nil then self.total_xp_change(self.guild_hall.effects['xp'].to_i) end
		# if self.guild_hall.effects['hp'] != nil then self.current_hp_change(self.guild_hall.effects['hp'].to_i) end
		# if self.guild_hall.effects['sp'] != nil then self.current_sp_change(self.guild_hall.effects['sp'].to_i) end
		# #end of Guild Hall

		# #Guild
		# if self.guild_hall.guild.effects['xp'] != nil then self.total_xp_change(self.guild_hall.guild.effects['xp'].to_i) end
		# if self.guild_hall.guild.effects['hp'] != nil then self.current_hp_change(self.guild_hall.guild.effects['hp'].to_i) end
		# if self.guild_hall.guild.effects['sp'] != nil then self.current_sp_change(self.guild_hall.guild.effects['sp'].to_i) end
		# #end of Guild

		self.save
		self.guild_hall.guild.save
	end
end