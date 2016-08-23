class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Devise
  before_action :authenticate_user!, except: [:welcome]
  before_action :gravatar_check

  def gravatar_check
	  if user_signed_in?
	  	@gravatar = current_user
	  else
	  	@gravatar = ''
	  end
	end
end
