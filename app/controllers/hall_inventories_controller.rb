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
	end

	def destroy
	end

	private
end
