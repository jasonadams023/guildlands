Rails.application.routes.draw do
	root 'static#welcome'
  	get 'static/welcome'
  	get 'static/admin'

  	devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
