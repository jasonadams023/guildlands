Rails.application.routes.draw do
	root 'static#welcome'
	devise_for :users, :controllers => { registrations: 'registrations' }

	resources :guilds
	resources :guild_abilities
	resources :locations
	resources :guild_halls
	resources :rooms
	resources :units
	resources :unit_abilities
	resources :items

  	get 'static/welcome'
  	get 'static/admin'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
