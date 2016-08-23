class OnTickJob < ApplicationJob
  queue_as :default

  def perform(*args)
  	#Units
    units = Unit.all
    activity = Activity.find(1)
    units.each do |unit|
    	unit.activity = activity
    	unit.save
    end
    #Economy
	items = Item.all
	items.each do |item|
		orders = MarketOrder.select{|o| o.item_id == item.id && o.price <= item.max_value}
		spent = 0
		percent = 0.1
		sales = []
		orders.each do |order|
			sales << [order, 0]
		end

		while spent < item.demand
			sales.each do |sale|
				if sale[0].price < (item.value * percent)
					spent += sale[0].price
					sale[1] += 1
				end
			end
			if (item.value * percent) < item.max_value then percent += 0.1 else percent = 0.1 end
		end

		sales.each do |sale|
			sale[0].npc_purchase(sale[1])
		end
	end
	#/Economy


  end
end
