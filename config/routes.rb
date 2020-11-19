Rails.application.routes.draw do

  root to: 'products#index'

  # Omniauth
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'users#create', as: 'omniauth_callback'

  delete '/logout', to: 'users#destroy', as: :logout
  get '/users/current', to: 'users#current_user', as: :current_user

  resources :products do
    post '/order_items', to: 'order_items#create'
  end

  resources :categories, except: [:destroy]
  resources :orders
  resources :order_items, only: [:create, :update, :destroy]
  resources :users

end