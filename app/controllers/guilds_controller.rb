class GuildsController < ApplicationController
	def index
	end
	
	def show
		@guild = current_user.guild
	end

	def new
	end

	def edit
	end
end
