class Unit < ApplicationRecord
	belongs_to :guild_hall
	belongs_to :activity

	has_one :unit_inventory
	has_many :items, through: :unit_inventory

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
end