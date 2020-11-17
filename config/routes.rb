Rails.application.routes.draw do

  root to: 'products#index'

  resources :products
  resources :categories, except: [:destroy]
  resources :orders
  resources :orderitems
  resources :users, except: [:destroy]

end
