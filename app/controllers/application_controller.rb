class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Devise
  before_action :authenticate_user!
end
