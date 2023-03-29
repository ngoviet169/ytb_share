Rails.application.routes.draw do

  resources :home

  post 'login', to: 'login#create', as: 'login_create'
  delete 'logout', to: 'login#destroy', as: 'logout'

  root 'home#index'
end