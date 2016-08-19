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
	end

	def purchase
		order = MarketOrder.find(params[:id])
		if params[:market_order][:guild_hall_id] != ''
			hall = GuildHall.find(params[:market_order][:guild_hall_id])
			amount = params[:market_order][:amount].to_i

			binding.pry

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

				if hall.save && order.save && hall.guild.save && hall.hall_inventories[id].save
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
			redirect_to market_order_path(order)
		end
	end

	def release
	end

	def destroy
	end

	private
end
