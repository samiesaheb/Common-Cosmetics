Rails.application.routes.draw do
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
end
