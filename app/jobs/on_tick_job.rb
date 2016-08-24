class OnTickJob < ApplicationJob
  queue_as :default

  def perform(*args)
  	#Units
    units = Unit.select{|u| u.guild_hall_id != nil}
    units.each do |unit|
    	unit.activity_run
    end
    #Economy
	items = Item.all
	items.each do |item|
		orders = MarketOrder.select{|o| o.item_id == item.id && o.price <= item.max_value && o.amount > 0 && o.category < 0}
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
						if sale[0].price < (item.value * percent)
							spent += sale[0].price
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
  end
end
