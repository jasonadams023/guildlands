# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

guilds = Guild.create([{name: 'Red Moon Rogues', total_rep: 500, spent_rep: 0, money: 1000, effects: {}},
						{name: 'Sacred Heart', total_rep: 1000, spent_rep: 500, money: 10000, effects: {}}])

locations = Location.create([{name: 'Lesure', description: 'A peaceful kingdom, where new guilds can flourish', effects: {upkeep_modifier: 0}},
								{name: 'Yaran Desert', description: 'A harsh land, with many opportunities', effects: {upkeep_modifier: 2, sales_modifier: 0.8}}])

guild_halls = GuildHall.create([{name: 'First Hall', size: 20, unit_limit: 10, effects: {activities: 'inn'}, guild_id: 1, location_id: 1},
								{name: 'Second', size: 10, unit_limit: 5, effects: {}, guild_id: 2, location_id: 2},
								{name: 'Third', size: 30, unit_limit: 10, effects: {activities: 'hospital'}, guild_id: 2, location_id: 1}])

activities = Activity.create([
								{name: 'Idle', description: 'This unit is not currently doing anything.', effects: {hp: 10, sp: 10}, location_id: nil, category: 'open'},
								{name: 'Quest', description: 'Go out looking for adventure.', effects: {hp: -20, sp: -20, reputation: 10, xp: 20}, location_id: nil, category: 'open'},
								{name: 'Gather (Lesure)', description: 'Go out and gather supplies from the surrounding area.', effects: {inventory1: '3_herb 2_wood 1_rabbit(dead)', sp: -10}, location_id: 1, category: 'location'},
								{name: 'Gather (Yaran)', description: 'Go out and gather supplies from the surrounding area.', effects: {inventory1: '3_desert*herb 2_cactus 1_snake(dead)', sp: -10}, location_id: 2, category: 'location'},
								{name: 'Mining (Lesure)', description: 'Go mining.', effects: {inventory1: '3_iron', sp: -10}, location_id: 1, category: 'location'},
								{name: 'Forge sword', description: 'Use iron to create a sword.', effects: {inventory1: '-5_iron 1_sword', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge chainmail', description: 'Use iron to create chainmail armor.', effects: {inventory1: '-3_iron 1_chainmail', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge breastplate', description: 'Use iron to create breastplate armor.', effects: {inventory1: '-5_iron 1_breastplate', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge full plate', description: 'Use iron to create fullplate armor.', effects: {inventory1: '-10_iron 1_full*plate', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge blacksmith hammer', description: 'Use iron and wood to create blacksmith hammer.', effects: {inventory1: '-3_iron -2_wood 1_blacksmith*hammer', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge leather boots', description: 'Use leather to create boots.', effects: {inventory1: '-5_leather 1_leather*boots', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge leather helmet', description: 'Use leather to create a helmet.', effects: {inventory1: '-3_leather 1_leather*helmet', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Forge iron helmet', description: 'Use iron to create a helmet.', effects: {inventory1: '-3_iron 1_iron*helmet', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Alchemy potion', description: 'Use herbs to create a potion.', effects: {inventory1: '-5_herb 1_potion'}, location_id: nil, category: 'crafting'},
								{name: 'Alchemy stamina potion', description: 'Use desert herbs to create a stamina potion.', effects: {inventory1: '-5_desert*herb 1_stamina*potion'}, location_id: nil, category: 'crafting'},
								{name: 'Process rabbit', description: 'Process a dead rabbit into meat and leather.', effects: {inventory1: '-1_rabbit(dead) 1_meat 1_leather', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Process snake', description: 'Process a dead snake into meat and leather.', effects: {inventory1: '-1_snake(dead) 1_meat 1_leather', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Cook stew', description: 'Cooks meat into stew.', effects: {inventory1: '-5_meat 1_stew', sp: -20}, location_id: nil, category: 'crafting'},
								{name: 'Heal Units', description: 'Process a dead rabbit into meat and leather.', effects: {hp: 20}, location_id: nil, category: 'hall'},
								{name: 'Arena: Race', description: 'Units race each other in the arena for reputation and rewards.', effects: {first_place: '100_rep 500_money', second_place: '75_rep 250_money', third_place: '50_rep 100_money', consolation: '50_xp', stats: 'agility'}, category: 'arena'},
								{name: 'Arena: Marathon', description: 'Units race each other in the arena for reputation and rewards.', effects: {first_place: '100_rep 500_money', second_place: '75_rep 250_money', third_place: '50_rep 100_money', consolation: '50_xp', stats: 'stamina'}, category: 'arena'},
								{name: 'Arena: Free for all', description: 'Units fight each other in the arena for reputation and rewards.', effects: {first_place: '100_rep 500_money', second_place: '75_rep 250_money', third_place: '50_rep 100_money', consolation: '50_xp', stats: 'strength'}, category: 'arena'},
								{name: 'Arena: Chess', description: 'Units compete in a chess tournament against each other in the arena for reputation and rewards.', effects: {first_place: '100_rep 500_money', second_place: '75_rep 250_money', third_place: '50_rep 100_money', consolation: '50_xp', stats: 'intelligence'}, category: 'arena'},
								{name: 'Arena: Staring Contest', description: 'Units compete in a staring contest against each other in the arena for reputation and rewards.', effects: {first_place: '100_rep 500_money', second_place: '75_rep 250_money', third_place: '50_rep 100_money', consolation: '50_xp', stats: 'focus'}, category: 'arena'},
								{name: 'Arena: Toughness', description: 'Units compete to see who is the toughest in the arena for reputation and rewards.', effects: {first_place: '100_rep 500_money', second_place: '75_rep 250_money', third_place: '50_rep 100_money', consolation: '50_xp', stats: 'vitality'}, category: 'arena'}
								])

units = Unit.create([{name: 'Ulbert', total_xp: 1000, spent_xp: 0, hiring_cost: 0, upkeep_cost: 10,
						max_hp: 50, current_hp: 50, max_sp: 50, current_sp: 50,
						strength: 5, agility: 5, vitality: 5, stamina: 5, intelligence: 5, focus: 5,
						dodge: 5, resilience: 0, resist: 5,
						effects: {}, guild_hall_id: 1, activity_id: 1}])

unit_abilities = UnitAbility.create([
									{name: 'Gatherer', description: 'This unit is better at gathering.', xp_cost: 50, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {gather_modifier: 2}},
									{name: 'Crafter', description: 'This unit is better at crafting items.', xp_cost: 50, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {crafting_modifier: 2}},
									{name: 'Mining', description: 'This unit is better at mining.', xp_cost: 50, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {mining_modifier: 2}},
									{name: 'Blacksmith', description: 'This unit is able to craft items at a forge.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {activities: 'Forge'}},
									{name: 'Alchemist', description: 'This unit is able to craft potions at an alchemy lab.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {activities: 'Alchemy'}},
									{name: 'Cook', description: 'This unit is able to cook food at a kitchen.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {activities: 'Cook'}},
									{name: 'Butcher', description: 'This unit is able to process animals at a butchery.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {activities: 'Process'}},
									#{name: 'Learner', description: 'This unit gains experience at an incresed rate.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {activities: 'Process'}},
									{name: 'Healthy', description: 'This unit regains hp at an incresed rate.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {hp: 10}},
									{name: 'Energetic', description: 'This unit regains sp at an increased rate.', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {sp: 10}}
									#{name: 'Doctor', description: 'This unit is able to heal units at a E.R..', xp_cost: 200, category: 'passive', ap_cost: 0, sp_cost: 0, effects: {activities: 'Heal'}}
									])

items = Item.create([
						{name: 'herb', description: 'A useful supply for medicinal uses', effects: {}, category: 'crafting', value: 10, max_value: 40, demand: 1000},
						{name: 'desert herb', description: 'A useful supply for medicinal uses. Found in the desert.', effects: {}, category: 'crafting', value: 15, max_value: 50, demand: 1500},
						{name: 'iron', description: 'A chunk of iron ore. Useful for crafting gear.', effects: {}, category: 'crafting', value: 30, max_value: 200, demand: 1500},
						{name: 'wood', description: 'A block of wood. Useful for building.', effects: {}, category: 'crafting', value: 20, max_value: 100, demand: 2000},
						{name: 'cactus', description: 'A prickly desert plant.', effects: {}, category: 'crafting', value: 15, max_value: 50, demand: 1000},
						{name: 'rabbit(dead)', description: 'A dead rabbit.', effects: {}, category: 'crafting', value: 25, max_value: 100, demand: 1500},
						{name: 'snake(dead)', description: 'A dead snake.', effects: {}, category: 'crafting', value: 25, max_value: 100, demand: 1500},
						{name: 'meat', description: 'A chunk of raw meat. Not fit for consumption.', effects: {}, category: 'crafting', value: 15, max_value: 50, demand: 3000},
						{name: 'leather', description: 'A piece of leather. Useful for crafting gear.', effects: {}, category: 'crafting', value: 20, max_value: 100, demand: 1500},
						{name: 'potion', description: 'Restores 15 hp.', effects: {hp: 15}, category: 'consumable', value: 50, max_value: 200, demand: 2000},
						{name: 'stamina potion', description: 'Restores 20 sp.', effects: {sp: 20}, category: 'consumable', value: 50, max_value: 200, demand: 2000},
						{name: 'stew', description: 'A tasty stew.', effects: {sp: 20, hp: 20}, category: 'consumable', value: 50, max_value: 250, demand: 2000},
						{name: 'sword', description: 'A sturdy sword.', effects: {slot: 'weapon', strength: 3}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'chainmail', description: 'Light body armor.', effects: {slot: 'body', vitality: 2}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'breastplate', description: 'Sturdy body armor.', effects: {slot: 'body', vitality: 4, stamina: -1}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'full plate', description: 'Heave body armor.', effects: {slot: 'body', vitality: 4, resilience: 3, agility: -2, stamina: -2}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'blacksmith hammer', description: 'A trusty hammer for blacksmiths. Improves crafting ability.', effects: {slot: 'weapon', strength: 2, crafting_modifier: 2}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'leather boots', description: 'Boots.', effects: {slot: 'boots', agility: 2}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'leather helmet', description: 'A light helmet.', effects: {slot: 'helmet', vitality: 2}, category: 'equippable', value: 100, max_value: 500, demand: 3000},
						{name: 'iron helmet', description: 'A sturdy helmet.', effects: {slot: 'helmet', vitality: 3, stamina: -1}, category: 'equippable', value: 100, max_value: 500, demand: 3000}
						])

guild_abilities = GuildAbility.create([{name: 'Team Work', rep_cost: 500, description: "Enables guild members to combine their attacks with each other.", effect: {gestalt: 1}},
										{name: 'Marketing', rep_cost: 500, description: "Increases the selling power of your entire guild.", effect: {sales_modifier: 0.8}},
										{name: 'Word of Mouth', rep_cost: 2000, description: "Increases the rate at which you gain more prestige.", effect: {rep_modifier: 2}}])

rooms = Room.create([{name: 'Bunk Room', size: 1, description: "Basic housing for your units.", effects: {unit_limit: 1}, cost: 200},
					{name: 'Bed Room', size: 2, description: "Medium housing for your units.", effects: {unit_limit: 2}, cost: 300},
					{name: 'Dorm', size: 3, description: "Large housing for your units.", effects: {unit_limit: 4}, cost: 800},
					{name: 'Forge', size: 3, description: "Room for making equipment.", effects: {activities: 'Forge'}, cost: 1000},
					{name: 'Kitchen', size: 3, description: "Room used for cooking food.", effects: {activities: 'Cook'}, cost: 500},
					{name: 'Alchemy Lab', size: 2, description: "Room used for creating potions.", effects: {activities: 'Alchemy'}, cost: 1000},
					{name: 'Buthery', size: 3, description: "Room used for processing animals.", effects: {activities: 'Process'}, cost: 500},
					{name: 'Sauna', size: 2, description: "Room for relaxation. Improves units sp restoration.", effects: {sp: 10}, cost: 800},
					{name: 'Medical Room', size: 4, description: "Improves units hp restoration.", effects: {hp: 10}, cost: 800},
					{name: 'Library', size: 3, description: "Room for learning. Units in this hall gain passive experience.", effects: {xp: 10}, cost: 800},
					{name: 'Advertisement', size: 1, description: "Not a room, but increases selling power for this hall.", effects: {sales_modifier: 0.9}, cost: 800}
					#{name: 'E.R.', size: 4, description: "Room used for emergency treatment.", effects: {activities: 'Heal'}, cost: 1500}
					])

hall_inventories = HallInventory.create([{guild_hall_id: 2, item_id: 10, available: 100, total: 600, selling: 500, using: 0}])

selling = MarketOrder.create([{hall_inventory_id: 1, item_id: 10, amount: 500, price: 20, category: -1},
								{hall_inventory_id: 1, item_id: 10, amount: 100, price: 10, category: 1}])