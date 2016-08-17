class GuildsController < ApplicationController
	def index
		user = current_user
		@guild = user.guild

		render :show
	end
  def show
  end

  def new
  end

  def edit
  end
end
