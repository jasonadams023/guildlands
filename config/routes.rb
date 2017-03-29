Rails.application.routes.draw do

	root 'static#welcome'
	devise_for :users, :controllers => { registrations: 'registrations' }

	resources :guilds
	resources :guild_abilities do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :locations
	resources :guild_halls do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :rooms do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :units do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :unit_abilities do
		post 'release', on: :member
		post 'purchase', on: :member
	end
	resources :items do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :hall_inventories do
		post 'release', on: :member
		post 'purchase', on: :member
	end
	resources :market_orders do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :unit_inventories
	resources :logs, only: :index

  	get 'static/welcome'
  	get 'static/admin'

  	#API Routes
  	get 'unity/new', to: 'unity_apps#new'
  	get 'unity/index', to: 'unity_apps#index'
  	get 'unity_apps/load/:username/:password', to: 'unity_apps#load'
  	post 'unity_apps/save/:username/:password', to: 'unity_apps#save'

  	get 'unity_apps/map/list/:query_type/:query', to: 'unity_apps#map_list' 
  	post 'unity_apps/map/save', to: 'unity_apps#save_map'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
