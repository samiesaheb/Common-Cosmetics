# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  get "/search", to: "search#index", as: :search

  root "posts#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  resources :comments

  # Follows
  resources :follows, only: [:create]
  delete "follows", to: "follows#destroy", as: :unfollow_follows

  # Polymorphic likes
  resources :likes, only: [:create]
  delete "likes", to: "likes#destroy", as: :unlike_likes

  # Users by id (explicit)
  get "/users/:id", to: "users#show", as: :user_profile

  # Products
  resources :products, only: [:show, :index] do
    collection { get :autocomplete }
  end

  # Notifications (explicit before catch-all)
  resources :notifications, only: [:index, :update] do
    collection { patch :mark_all_read }
  end

  # Catch-all username LAST with reserved words excluded
  reserved = /rails|up|search|users|posts|comments|likes|follows|products|notifications|assets|packs|favicon\.ico/
  get "/:username", to: "users#show", as: :username_profile,
      constraints: { username: /(?!#{reserved})([A-Za-z0-9_\.]+)/ }
end
