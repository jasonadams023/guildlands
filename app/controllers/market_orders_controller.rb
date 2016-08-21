class MarketOrdersController < ApplicationController
	def index
		if params[:item_id] != nil
			@orders = MarketOrder.all.select{|o| o.item_id == params[:item_id].to_i}
		else
			@orders = MarketOrder.all
		end
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

		order.guild_hall_id = inventory.guild_hall_id
		order.item_id = inventory.item_id

		inventory.selling += order.amount
		inventory.available -= order.amount

		if inventory.save && order.save
			flash[:notice] = "Created new market order."
		else
			flash[:alert] = "Failed to update."
		end
		redirect_to inventory
	end

	def purchase
		order = MarketOrder.find(params[:id])
		if params[:market_order][:guild_hall_id] != ''
			hall = GuildHall.find(params[:market_order][:guild_hall_id])
			amount = params[:market_order][:amount].to_i

			if hall.guild.money >= order.price * amount
				if !(hall.items.include?(order.item))
					hall.items << order.item
					id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
					hall.hall_inventories[id].total = 0
					hall.hall_inventories[id].available = 0
					hall.hall_inventories[id].selling = 0
				else
					id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
				end
				
				hall.hall_inventories[id].total += amount
				hall.hall_inventories[id].available += amount
				hall.guild.money -= order.price * amount


				id2 = order.guild_hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
				order.amount -= amount
				order.guild_hall.guild.money += order.price * amount
				order.guild_hall.hall_inventories[id2].total -= amount
				order.guild_hall.hall_inventories[id2].selling -= amount

				if hall.save && hall.guild.save && hall.hall_inventories[id].save
					if order.save && order.guild_hall.save && order.guild_hall.hall_inventories[id2].save && order.guild_hall.guild.save
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

			redirect_to hall
		else
			flash[:alert] = "No destination selected."
			redirect_to market_order_path(order)
		end
	end

	def release
	end

	def destroy
	end

	private
		def order_params
			params.require(:market_order).permit(:guild_hall_id, :item_id, :amount, :price)
		end
end
