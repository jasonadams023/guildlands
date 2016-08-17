class StaticController < ApplicationController
  def welcome
  	@guild = current_user.guild
  end

  def admin
  end
end
