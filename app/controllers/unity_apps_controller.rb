class UnityAppsController < ApplicationController
	def new
	end

	def index
	end

	def login
		if authenticate_user
			user = User.find_for_authentication(:username => params[:username])
			guild = user.guild
			halls = guild.guild_halls
			units = []

			halls.each do |hall|
				hall.units.each do |unit|
					units << unit
				end
			end

			render json: units
		else
			render json: "false"
		end
	end

	private
		def authenticate_user
			user = User.find_for_authentication(:username => params[:username])

			if user.active_for_authentication? && user.valid_password?(params[:password])
				true
			else
				false
			end
		end
end
