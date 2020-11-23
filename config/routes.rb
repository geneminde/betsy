Rails.application.routes.draw do

  get '/cart', to: 'orders#cart'
  root to: 'products#index'

  # Omniauth
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'users#create', as: 'omniauth_callback'

  delete '/logout', to: 'users#destroy', as: :logout
  get '/users/current', to: 'users#current_user', as: :current_user

  patch 'users/current/:product_id/retire', to: 'products#retire', as: :retire_product

  patch 'order_items/:id/ship', to: 'order_items#ship', as: 'ship'

  resources :products do
    resources :order_items, only: [:create]
  end

  resources :categories, except: [:destroy]

  resources :orders, except: [:destroy] do
    get '/confirmation', to: 'orders#confirmation'
  end

  resources :order_items, only: [:create, :update, :destroy]
  resources :users

end