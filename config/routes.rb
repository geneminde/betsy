Rails.application.routes.draw do

  root to: 'products#index'

  # Omniauth
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'users#create', as: 'omniauth_callback'

  delete '/logout', to: 'users#destroy', as: :logout
  get '/users/current', to: 'users#current', as: :current_user

  resources :products
  resources :categories, except: [:destroy]
  resources :orders
  resources :orderitems
  resources :users

end
