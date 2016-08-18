class GuildAbilitiesController < ApplicationController
	def index
	end

	def show
		@ability = GuildAbility.find(params[:id])
	end

	def new
	end

	def edit
	end
end
