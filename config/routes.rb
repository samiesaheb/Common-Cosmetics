Rails.application.routes.draw do
  
  mount ActionCable.server => '/cable'

  get "bookmarks/create"
  get "bookmarks/destroy"
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

  # 🔍 MOVE THIS UP — before `resources :users`
  get "users/autocomplete", to: "users#autocomplete"

  # Posts with nested comments and likes
  resources :posts do
    get :more, on: :collection
    get :more_comments, on: :member

    resource :like, only: [:create, :destroy], controller: 'post_likes'
    resources :comments, only: [:create, :destroy] do
      resource :like, only: [:create, :destroy], controller: "comment_likes"
    end
    
    resource :bookmark, only: [:create, :destroy]
    resource :repost, only: [:create, :destroy]
  end

  resources :notifications, only: [:index] do
    collection do
      post :mark_all_as_read
    end

    member do
      get :mark_as_read
    end
  end

  # ✅ This must come after `autocomplete`
  resources :users, only: [:show], param: :username do
    post :follow, to: "follows#create", as: :follow
    delete :unfollow, to: "follows#destroy", as: :unfollow
  end

  get "search", to: "search#index", as: :search

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create, :destroy]
    member do
      post :update_typing
    end
  end

  resources :product_tags, only: [:index, :show]
end
