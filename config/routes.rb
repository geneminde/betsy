Rails.application.routes.draw do

  root to: 'products#index'

  # Omniauth
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'users#create', as: 'omniauth_callback'

  resources :products
  resources :categories, except: [:destroy]
  resources :orders
  resources :orderitems
  resources :users, except: [:destroy]

end
