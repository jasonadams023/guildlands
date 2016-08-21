class HallInventoriesController < ApplicationController
	def index
		if params[:guild_hall_id] != ''
			hall = GuildHall.find(params[:guild_hall_id].to_i)
			@inventories = hall.hall_inventories
		elsif params[:guild_id] != ''
			guild = Guild.find(params[:guild_id])
			@inventories = []
			guild.guild_halls.each do |hall|
				hall.hall_inventories.each do |inventory|
					@inventories << inventory
				end
			end
		else
			@inventories = HallInventory.all
		end
	end

	def show
		@inventory = HallInventory.find(params[:id])
		@order = MarketOrder.new
	end

	def new
	end

	def edit
	end

	def create
	end

	def purchase
	end

	def release
		inventory = HallInventory.find(params[:id])
		hall = inventory.guild_hall
		guild = hall.guild
		order = MarketOrder.new

		inventory.selling += params[:hall_inventory][:selling]
		inventory.availabe -= params[:hall_inventory][:selling]

		order.guild_hall_id = hall.id
		order.item_id = inventory.item_id
		order.amount = params[:hall_inventory][:selling]
		order.price = params[:hall_inventory][:price]

		if inventory.save && order.save
			flash[:notice] = "Created new market order."
		else
			flash[:alert] = "Failed to update."
		end

		redirect_to inventory
	end

	def destroy
	end

	private
end
