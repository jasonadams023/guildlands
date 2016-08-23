module ApplicationHelper
	def avatar_url(user)
		if user_signed_in?
			gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
		else
			gravatar_id = Digest::MD5.hexdigest(user)
		end
		return "http://gravatar.com/avatar/#{gravatar_id}.png?s=24&d=identicon"
	end

	def economy
		binding.pry
		#max = value * 4
    #demand = numeric value
    # every 10% = double/half?
		items = Item.all
		items.each do |item|
			orders = MarketOrder.select{|o| o.item_id == item.id && o.price <= item.max_value}
			spent = 0
			percent = 0.1
			while spent < item.demand
				order.each do |order|
					if order.price < item.value * percent then spent += order.npc_purchase end
					if (item.value * percent) < item.max_value then percent += 0.1 else percent = 0.1 end
				end
			end
		end
	end
end
