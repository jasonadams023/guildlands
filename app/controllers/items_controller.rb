class ItemsController < ApplicationController
	def index
		@market_orders = MarketOrder.all
	end

	def show
		if params[:market] == "true"
			@order = MarketOrder.find(params[:id])
		else
			@inventory = HallInventory.find(params[:id])
		end
	end

	def new
	end

	def edit
	end

	def create
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
				else
					id = hall.hall_inventories.find_index{|o| order.item_id == o.item_id}
				end
				
				hall.hall_inventories[id].total += amount
				hall.guild.money -= order.price * amount
				order.amount -= amount

				binding.pry

				if hall.save && order.save && hall.guild.save
					flash[:notice] = "Purchase successful."
				else
					flash[:alert] = "Failed to update."
				end
			else
				flash[:alert] = "Guild does not have enough money to complete that purchase."
			end

			redirect_to hall
		else
			flash[:alert] = "No destination selected."
			redirect_to item_path(order)
		end
	end

	def release
	end

	def destroy
	end

	private
end
