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
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :items do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :hall_inventories do
		get 'release', on: :member
		post 'purchase', on: :member
	end
	resources :market_orders do
		get 'release', on: :member
		post 'purchase', on: :member
	end

  	get 'static/welcome'
  	get 'static/admin'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
