class UnitsController < ApplicationController
	def index
	end

	def show
		@unit = Unit.find(params[:id])
	end

	def new
		@guild = current_user.guild
		@unit = Unit.new
	end

	def edit
		@guild = current_user.guild
		@unit = Unit.new
	end

	def create
		@unit = Unit.new(unit_params)
		set_stats
		set_ids
		@unit.effects = {}

		if @unit.save
			flash[:notice] = "Created new unit."
			redirect_to current_user.guild
		else
			flash[:alert] = "Failed to save unit."
			@guild = current_user.guild
			@unit = Unit.new
			render :edit
		end
	end

	def release
		@unit = Unit.find(params[:id])
		@unit.guild_hall = nil
		@unit.guild = nil
		@unit.location = nil
		@unit.activity = Activity.find(1)
		binding.pry

		if @unit.save
			flash[:notice] = "Unit released."
		else
			flash[:alert] = "Failed to release unit."
		end

		redirect_to guild_path(current_user.guild.id)
	end

	def destroy
	end

	private
		def unit_params
			params.require(:unit).permit(:name, :total_xp, :guild_hall_id,
                                        :strength, :agility, :vitality,
                                        :stamina, :intelligence, :focus)
		end

		def set_spent_xp
	        @unit.spent_xp = 0
	    end

	    def set_costs
	    	@unit.hiring_cost = @unit.total_xp
	    	@unit.upkeep_cost = 10
	    end
	    
	    def set_HP
	        @unit.max_hp = @unit.vitality * 10
	    end
	    
	    def set_SP
	        @unit.max_sp = @unit.stamina * 10
	    end
	    
	    def set_defenses
	        @unit.dodge = @unit.agility
	        @unit.resilience = 0
	        @unit.resist = @unit.intelligence
	    end
	    
	    def full_heal
	        @unit.current_hp = @unit.max_hp
	        @unit.current_sp = @unit.max_sp
	    end

	    def set_ids
	    	@unit.guild = @unit.guild_hall.guild
	    	@unit.location = @unit.guild_hall.location
	    	@unit.activity = Activity.find(1)
	    end
	    
	    def set_stats #for creating or updating characters
	        set_HP
	        set_SP
	        full_heal
	        set_defenses
	        set_spent_xp
	        set_costs
	    end
end