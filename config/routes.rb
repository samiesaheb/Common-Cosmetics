Rails.application.routes.draw do
  devise_for :users

  # Main feed
  root "posts#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Posts
  resources :posts
  resources :comments
  resources :follows, only: [:create, :destroy]

  # Polymorphic likes
  resources :likes, only: [:create]
  delete "likes", to: "likes#destroy", as: :unlike_likes

  # Public profiles
  get "/users/:id", to: "users#show", as: :user_profile
  get "/:username", to: "users#show", as: :username_profile
end
