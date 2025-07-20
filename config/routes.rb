Rails.application.routes.draw do
  get "users/show"
  get "notifications/index"
  # Devise authentication routes
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "posts#index"

  # Posts with nested comments and likes
  resources :posts do
    get :more_comments, on: :member

    # Post likes (❤️)
    resource :like, only: [:create, :destroy]

    # Comments on posts
    resources :comments, only: [:create, :destroy] do
      # Comment likes (❤️)
      resource :like, only: [:create, :destroy], controller: "comment_likes"
    end
  end

  resources :notifications, only: [:index] do
    collection do
      post :mark_all_as_read
    end

    member do
      post :mark_as_read
    end
  end

  resources :users, only: [:show], param: :username do
    post :follow, to: "follows#create"
    delete :unfollow, to: "follows#destroy"
  end

  get "users/autocomplete", to: "users#autocomplete"


end
