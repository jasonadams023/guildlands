class LogsController < ApplicationController
  def index
  	@logs = Log.select{|log| log.guild_id == current_user.guild.id}
  end
end
