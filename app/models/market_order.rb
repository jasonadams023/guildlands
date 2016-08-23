class MarketOrder < ApplicationRecord
  belongs_to :hall_inventory, dependent: :destroy
  belongs_to :item

  #Methods
  def npc_purchase
  	if self.amount > 0
  		self.amount -= 1
  		self.hall_inventory.total -= 1
  		self.hall_inventory.selling -= 1
  		self.hall_inventory.guild_hall.guild.money += price

  		self.save
  		self.hall_inventory.save
  		self.hall_inventory.guild_hall.guild.save

  		return amount
  	else
  		return 0
  	end
  end
end
# f purchase
# 		order = MarketOrder.find(params[:id])
# 		if params[:market_order][:hall_inventory_id] != ''
# 			hall = GuildHall.find(params[:market_order][:hall_inventory_id])
# 			amount = params[:market_order][:amount].to_i

# 			if hall.guild.money >= order.price * amount
# 				if !(hall.items.include?(order.item))
# 					hall.items << order.item
# 					id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
# 					inventory = hall.hall_inventories[id]
# 					inventory.total = 0
# 					inventory.available = 0
# 					inventory.selling = 0
# 				else
# 					id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
# 					inventory = hall.hall_inventories[id]
# 				end
				
# 				inventory.total += amount
# 				inventory.available += amount
# 				hall.guild.money -= order.price * amount

# 				order.amount -= amount
# 				order.hall_inventory.guild_hall.guild.money += order.price * amount
# 				order.hall_inventory.total -= amount
# 				order.hall_inventory.selling -= amount

# 				if hall.save && hall.guild.save && inventory.save
# 					if order.save && order.hall_inventory.save && order.hall_inventory.guild_hall.save && order.hall_inventory.guild_hall.guild.save
# 						flash[:notice] = "Purchase successful."
# 					else
# 						flash[:alert] = "Failed to update sellers info."
# 					end
# 				else
# 					flash[:alert] = "Failed to update your info."
# 				end
# 			else
# 				flash[:alert] = "Guild does not have enough money to complete that purchase."
# 			end

# 			redirect_to hall
# 		else
# 			flash[:alert] = "No destination selected."
# 			redirect_to market_order_path(order)
# 		end