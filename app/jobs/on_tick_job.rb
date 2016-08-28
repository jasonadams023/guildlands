class OnTickJob < ApplicationJob
  queue_as :default

  @@turn = 0

  def self.turn
  	return @@turn
  end

  def perform(*args)
  	#Setup
  	@@turn += 1

  	#Log setup
  	log_guilds = []
  	log_halls = []
  	log_units = []

  	Guild.all.each do |guild|
  		log_guilds << {id: guild.id, money: guild.money}
  	end

  	GuildHall.select{|h| h.guild_id != nil}.each do |hall|
  		hash = {}
  		hash[:id] = hall.id
  		hash[:inv] = []
  		hall.hall_inventories.each do |inv|
  			hash[:inv] << {id: inv.id, total: inv.total, selling: inv.selling}
  		end
  		log_halls << hash
  	end

  	Unit.select{|u| u.guild_hall_id != nil}.each do |unit|
  		log_units << {id: unit.id, total_xp: unit.total_xp, current_hp: unit.current_hp, current_sp: unit.current_sp,
  						strength: unit.strength, agility: unit.agility, vitality: unit.vitality,
  						stamina: unit.stamina, intelligence: unit.intelligence, focus: unit.focus}
	end

  	#Units
    units = Unit.select{|u| u.guild_hall_id != nil}
    units.each do |unit|
    	unit.on_tick
    end

    #Economy
	items = Item.all
	items.each do |item|
		orders = MarketOrder.select{|o| o.item_id == item.id && o.price_sum <= item.max_value && o.amount > 0 && o.category < 0}
		spent = 0
		sales = []
		orders.each do |order|
			sales << [order, 0]
		end

		if sales.length > 0 #To prevent infinite loops if there are no market orders for a particular item
			target_percent = 0.1
			while spent < item.demand
				percent = 0.1
				while percent <= target_percent
					sales.each do |sale|
						if sale[0].price_sum < (item.value * percent)
							spent += sale[0].price_sum
							sale[1] += 1
						end
					end
					percent += 0.1
				end
				if (item.value * target_percent) < item.max_value then target_percent += 0.1 else target_percent = 0.1 end
			end
		end

		sales.each do |sale|
			sale[0].npc_purchase(sale[1])
		end
	end
	#/Economy

	#Log complete
		#guilds
	log_guilds.each do |guild|
		saved = Guild.find(guild[:id])
		log = Log.my_new

		log.turn = @@turn
		log.guild = saved
		log.data[:guild] = saved.name
		log.message = "#{log.data[:guild]}: "

		if saved.money != guild[:money]
			log.data[:money] = saved.money - guild[:money]
			if log.data[:money] > 0 then word = 'Gained' else word = 'Lost' end
			log.message += "#{word} #{log.data[:money]} money."
		end

		if log.data.length > 1 then log.save end
	end

		#halls
	log_halls.each do |hall|
		saved = GuildHall.find(hall[:id])
		log = Log.my_new

		log.turn = @@turn
		log.guild = saved.guild
		log.data[:guild_hall] = saved.name
		log.message = "#{log.data[:guild_hall]}: "

		saved.hall_inventories.each do |inventory|

			index = hall[:inv].find_index{|i| i[:id] == inventory.id}
			if index == nil
				log.data[inventory.item.name] = inventory.total
				log.message += "Gained #{log.data[inventory.item.name]} #{inventory.item.name}."
			else
				log_inv = hall[:inv][index]
				if log_inv[:total] != inventory.total
					log.data[inventory.item.name] = inventory.total - log_inv[:total]
					if log.data[inventory.item.name] > 0 then word = 'Gained' else word = 'lost' end
					log.message += "#{word} #{log.data[inventory.item.name]} #{inventory.item.name}."
				end
				if log_inv[:selling] != inventory.selling
					log.data['sold #{inventory.item.name}'] = inventory.selling - log_inv[:selling]
					log.message += "\nSold #{log.data[inventory.item.name]} #{inventory.item.name}."
				end
			end
		end

		if log.data.length > 1 then log.save end
	end

		#units
	log_units.each do |unit|
		saved = Unit.find(unit[:id])
		log = Log.my_new

		log.turn = @@turn
		log.guild = saved.guild_hall.guild
		log.data[:unit] = saved.name
		log.message = "#{log.data[:unit]}: "

		if saved.total_xp != unit[:total_xp]
			log.data[:total_xp] = saved.total_xp - unit.total_xp
			if log.message[-1] == '.' then new_line = '\n' else new_line = '' end
			if log.data[:total_xp] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:total_xp]} experience."
		end
		if saved.current_hp != unit[:current_hp]
			log.data[:current_hp] = saved.current_hp - unit.current_hp
			if log.data[:current_hp] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:current_hp]} hp."
		end
		if saved.current_sp != unit[:current_sp]
			log.data[:current_sp] = saved.current_sp - unit.current_sp
			if log.data[:current_sp] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:current_sp]} sp."
		end
		if saved.strength != unit[:strength]
			log.data[:strength] = saved.strength - unit.strength
			if log.data[:strength] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:strength]} strength."
		end
		if saved.agility != unit[:agility]
			log.data[:agility] = saved.agility - unit.agility
			if log.data[:agility] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:agility]} agility."
		end
		if saved.vitality != unit[:vitality]
			log.data[:vitality] = saved.vitality - unit.vitality
			if log.data[:vitality] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:vitality]} vitality."
		end
		if saved.stamina != unit[:stamina]
			log.data[:stamina] = saved.stamina - unit.stamina
			if log.data[:stamina] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:stamina]} stamina."
		end
		if saved.intelligence != unit[:intelligence]
			log.data[:intelligence] = saved.intelligence - unit.intelligence
			if log.data[:intelligence] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:intelligence]} intelligence."
		end
		if saved.focus != unit[:focus]
			log.data[:focus] = saved.focus - unit.focus
			if log.data[:focus] > 0 then word = 'Gained' else word = 'lost' end
			log.message += "#{new_line}#{word} #{log.data[:focus]} focus."
		end

		if log.data.length > 1 then log.save end
	end
  end
end