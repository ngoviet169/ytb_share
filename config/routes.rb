Rails.application.routes.draw do

  resources :home

  resources :videos

  post 'login', to: 'login#create', as: 'login_create'
  delete 'logout', to: 'login#destroy', as: 'logout'
  get 'like_video/:video_id', to: 'home#like_video', as: 'like_video'
  get 'dislike_video/:video_id', to: 'home#dislike_video', as: 'dislike_video'

  root 'home#index'
end
