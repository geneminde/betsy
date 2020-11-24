Rails.application.routes.draw do

  get '/cart', to: 'orders#cart'
  root to: 'products#index'

  # Omniauth
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'users#create', as: 'omniauth_callback'

  delete '/logout', to: 'users#destroy', as: :logout
  get '/users/current', to: 'users#current_user', as: :current_user
  get '/users/current/orders/:id', to: 'orders#merchant_order', as: 'merchant_order'


  patch 'users/current/:product_id/retire', to: 'products#retire', as: :retire_product

  patch 'order_items/:id/ship', to: 'order_items#ship', as: 'ship'

  resources :products do
    resources :order_items, only: [:create]
    resources :reviews
  end

  resources :categories, except: [:destroy]

  resources :orders, except: [:destroy] do
    get '/confirmation', to: 'orders#confirmation'
  end
  get '/users/current/orders', to: 'orders#index'

  resources :order_items, only: [:create, :update, :destroy]
  resources :users

end