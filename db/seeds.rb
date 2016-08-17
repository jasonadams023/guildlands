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
								{name: 'Third', size: 30, unit_limit: 10, effects: {activities: 'hospital'} guild_id: 2, location_id: 1}])
