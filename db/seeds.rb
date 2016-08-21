# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

guilds = Guild.create([{name: 'Red Moon Rogues', total_rep: 500, spent_rep: 0, money: 1000, effects: {first: 'hello', second: 'world'}},
						{name: 'Sacred Heart', total_rep: 1000, spent_rep: 500, money: 10000, effects: {awesomeness: 'double intelligence'}}])

locations = Location.create([{name: 'Lesure', description: 'A peaceful kingdom, where new guilds can flourish', effects: {taxes: 'none'}},
								{name: 'The Great Desert', description: 'A harsh land, with many opportunities', effects: {upkeep: 'doubled', resources: 'doubled'}}])

guild_halls = GuildHall.create([{name: 'First Hall', size: 20, unit_limit: 10, effects: {activities: 'inn'}, guild_id: 1, location_id: 1},
								{name: 'Second', size: 10, unit_limit: 5, effects: {}, guild_id: 2, location_id: 2},
								{name: 'Third', size: 30, unit_limit: 10, effects: {activities: 'hospital'}, guild_id: 2, location_id: 1}])

activities = Activity.create([{name: 'Idle', description: 'This unit is not currently doing anything.', effects: {stats: 'heal'}},
								{name: 'Gather', description: 'Go out and gather supplies from the surrounding area.', effects: {inventory: 'add_regional_stamina'}, location_id: 1},
								{name: 'Gather', description: 'Go out and gather supplies from the surrounding area.', effects: {inventory: 'add_regional_stamina'}, location_id: 2}])

units = Unit.create([{name: 'Ulbert', total_xp: 1000, spent_xp: 0, hiring_cost: 0, upkeep_cost: 10,
						max_hp: 50, current_hp: 50, max_sp: 50, current_sp: 50,
						strength: 5, agility: 5, vitality: 5, stamina: 5, intelligence: 5, focus: 5,
						dodge: 5, resilience: 0, resist: 5,
						effects: {}, guild_hall_id: 1, activity_id: 1}])

unit_abilities = UnitAbility.create([{name: 'Gatherer', description: 'This unit is better at gathering', xp_cost: 50, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {gathering: 'doubled'}}])

items = Item.create([{name: 'potion', description: 'Restores 15 hp.', effects: {current_hp: '+15'}, category: 'consumable', value: 50}])

guild_abilities = GuildAbility.create([{name: 'Team Work', rep_cost: 500, description: "Enables guild members to combine their attacks with each other.", effect: {gestalt: 'enable'}},
										{name: 'Marketing', rep_cost: 500, description: "Increases the selling power of your entire guild.", effect: {sales: 'double'}},
										{name: 'Word of Mouth', rep_cost: 2000, description: "Increases the rate at which you gain more prestige.", effect: {rep_gain: 'double'}}])

rooms = Room.create([{name: 'Bunk Room', size: 1, description: "Basic housing for your units.", effects: {unit_limit: 1}, cost: 200},
					{name: 'Bed Room', size: 2, description: "Medium housing for your units.", effects: {unit_limit: 2}, cost: 300},
					{name: 'Dorm', size: 3, description: "Large housing for your units.", effects: {unit_limit: 4}, cost: 800}])

hall_inventories = HallInventory.create([{guild_hall_id: 2, item_id: 1, available: 100, total: 600, selling: 500}])

selling = MarketOrder.create([{hall_inventory_id: 1, item_id: 1, amount: 500, price: 20}])