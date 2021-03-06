class UnityAppsController < ApplicationController
	protect_from_forgery unless: -> { request.format.json? }

	def new
	end

	def index
	end

	def load
		user = authenticate_user
		if user != false

			playerData = build_player_data(user)
			output = playerData
		else
			output = "false"
		end

		render json: output
	end

	def save
		user = authenticate_user
		if user != false

			# render json: params[:data]
			unityGuild = params[:guild]
			guild = Guild.find(unityGuild[:id])
			guild.money = unityGuild[:money]
			guild.total_rep = unityGuild[:total_rep]
			unless guild.save
				render json: "false"
			end


			units = params[:units]
			units.each do |u|
				unit = Unit.find(u[:id])
				if unit != nil
					unit.total_xp = u[:total_xp]
					unit.max_hp = u[:max_hp]
					unit.max_sp = u[:max_sp]
					unless unit.save
						render json: "false"
					end
				end
			end

			#unityGuild = Guild.new
			#unityGuild.assign_attributes(JSON.parse(playerData["guild"]))
			# guild = Guild.find(unityGuild.id)
			# unityHalls = []
			# halls = []
			# unityUnits = []
			# units = []

			# playerData["halls"].each do |hall|
			# 	unityHall = new Hall(JSON.parse(hall))
			# 	unityHalls << unityHall
			# 	halls << Hall.find(unityHall.id)
			# end

			# playerData["units"].each do |unit|
			# 	unityUnit = new Unit(JSON.parse(unit))
			# 	unityUnits << new Unit(JSON.parse(unit))
			# 	unit << Unit.find(unityUnit.id)
			# end


		else
			render json: "false"
		end

		render json: "true"
	end

	#Maps
	def map_list
		if params[:query_type] == "guild_id"
			guild_id = params[:query].to_i
			if guild_id > 0
				maps = Map.all.select{|m| m.guild_id == guild_id}
				output = build_map_list(maps)
			else
				output = "false"
			end
		else
			output = "false"
		end

		render json: output
	end

	def save_map
		unity_map = params[:unity_app]
		guild = Guild.find(unity_map[:guild_id])
		if Map.exists?(:guild_id => guild.id, :name => unity_map[:name])
			map = Map.find(:guild_id => guild.id, :name => unity_map[:name])
		else
			map = Map.new
			map.guild_id = unity_map[:guild_id]
			map.name = unity_map[:guild_id]
		end

		map.name = unity_map[:name]
		map.dimensions = unity_map[:dimensions]
		map.tile_types = unity_map[:tile_types]

		if map.save
			output = "true"
		else
			output = "false"
		end

		# output = "false"

		render json: output
	end
	#Maps

	private
		def authenticate_user
			user = User.find_for_authentication(:username => params[:username])

			if user != nil && user.active_for_authentication? && user.valid_password?(params[:password])
				user
			else
				false
			end
		end

		def build_player_data (user)
			data = {}
			data["guild"] = user.guild
			data["halls"] = data["guild"].guild_halls
			units = []

			data["halls"].each do |hall|
				hall.units.each do |unit|
					units << unit
				end
			end

			data["units"] = units

			return data
		end

		def build_map_list(maps)
			list = {}
			list["list"] = maps

			return list
		end
end
