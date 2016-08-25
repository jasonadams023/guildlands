class MarketOrdersController < ApplicationController
	def index
		if params[:item_id] != nil
			@orders = MarketOrder.all.select{|o| o.item_id == params[:item_id].to_i && o.amount > 0}
		elsif params[:guild_id] != nil
			@orders = MarketOrder.all.select{|o| o.hall_inventory.guild_hall.guild.id == params[:guild_id].to_i}
		else
			@orders = MarketOrder.select{|o| o.amount > 0}
		end

		@sells = @orders.select{|o| o.category < 0}
		@buys = @orders.select{|o| o.category > 0}
	end

	def show
		@order = MarketOrder.find(params[:id])
	end

	def new
	end

	def edit
	end

	def create
		inventory = HallInventory.find(params[:inventory_id])
		order = MarketOrder.new(order_params)

		if !(order.amount == nil || order.price == nil)

			order.hall_inventory_id = inventory.id
			order.item_id = inventory.item_id
			order.category = -1

			inventory.selling += order.amount
			inventory.available -= order.amount

			if inventory.save && order.save
				flash[:notice] = "Created new market order."
			else
				flash[:alert] = "Failed to update."
			end
		else
			flash[:alert] = "Form not filled out."
		end
		redirect_to inventory
	end

	def purchase
		order = MarketOrder.find(params[:id])
		if params[:market_order][:hall_inventory_id] != ''
			hall = GuildHall.find(params[:market_order][:hall_inventory_id])
			amount = params[:market_order][:amount].to_i

			if order.category < 0 #if it is a sell order
				if hall.guild.money >= order.price * amount
					if !(hall.items.include?(order.item))
						hall.items << order.item
						id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
						inventory = hall.hall_inventories[id]
						inventory.total = 0
						inventory.available = 0
						inventory.selling = 0
						inventory.using = 0
					else
						id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
						inventory = hall.hall_inventories[id]
					end
					
					inventory.total += amount
					inventory.available += amount
					hall.guild.money -= order.price * amount

					order.amount -= amount
					order.hall_inventory.guild_hall.guild.money += order.price * amount
					order.hall_inventory.total -= amount
					order.hall_inventory.selling -= amount

					if hall.save && hall.guild.save && inventory.save
						if order.save && order.hall_inventory.save && order.hall_inventory.guild_hall.save && order.hall_inventory.guild_hall.guild.save
							flash[:notice] = "Purchase successful."
						else
							flash[:alert] = "Failed to update sellers info."
						end
					else
						flash[:alert] = "Failed to update your info."
					end
				else
					flash[:alert] = "Guild does not have enough money to complete that purchase."
				end
			elsif order.category > 0 #if it is a buy order
				if hall.items.include?(order.item)
					id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
					inventory = hall.hall_inventories[id]
					if inventory.available >= amount
						if order.hall_inventory.guild_hall.guild.money >= order.price * amount
							
							order.amount -= amount
							order.hall_inventory.total += amount
							order.hall_inventory.available += amount
							order.hall_inventory.guild_hall.guild.money -= order.price * amount

							inventory.total -= amount
							inventory.available -= amount
							hall.guild.money += order.price * amount

							if order.save && order.hall_inventory.save && order.hall_inventory.guild_hall.save && order.hall_inventory.guild_hall.guild.save
								if inventory.save && hall.save && hall.guild.save
									flash[:notice] = "Sale successful."
								else
									flash[:alert] = "Failed to update your info."
								end
							else
								flash[:alert] = "Failed to update the buyers info."
							end
						else
							flash[:alert] = "Their guild does not have enough money to complete the transaction."
						end
					else
						flash[:alert] = "This guild hall does not have enough of that item to complete the transaction."
					end
				else
					flash[:alert] = "This guild hall does not have that item to sell."
				end
			else
				flash[:alert] = "This is not a buy or sell order."
			end

			redirect_to hall
		else
			flash[:alert] = "No destination selected."
			redirect_to market_order_path(order)
		end
	end

	def release
	end

	def destroy
		order = MarketOrder.find(params[:id])
		inventory = HallInventory.find(order.hall_inventory_id)

		inventory.selling -= order.amount
		inventory.available += order.amount

		if inventory.save && order.delete
			flash[:notice] = "Order cancellation successful."
		else
			if inventory.save
				flash[:alert] = "Failed to delete order."
			else
				flash[:alert] = "Failed to update inventory."
			end
			redirect_to order
		end
		redirect_to inventory
	end

	private
		def order_params
			params.require(:market_order).permit(:hall_inventory_id, :item_id, :amount, :price)
		end
end
