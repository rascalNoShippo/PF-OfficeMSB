Rails.application.routes.draw do
  devise_for :users, skip: [:password, :registrations], controllers: {
    sessions: "users/sessions",
    passwords: "users/passwords"
  }
  
  get "users/config", to: "user_config#edit", as: "edit_user_config"
  patch "users/config", to: "user_config#update", as: "user_config"

  resources :users, only: [:show, :edit, :update, :new, :create, :index, :destroy] do
    patch "invalidate"
    patch "activate"
    get "password", to: "users#password_edit"
    patch "password", to: "users#password_update"
  end
  
  resources :favorites, only: [:index, :create, :destroy]

  resources :messages do
    member do
      get "receivers"
      patch "trash"
      patch "restore"
    end
    resources :message_comments, only: [:create, :destroy], as: "comments"
  end

  post "search_users", to: "search_users#search_users", as: "search_users"

  resources :bulletin_boards do
    resources :bulletin_board_comments, only: [:create, :destroy], as: "comments"
  end

  root to: "homes#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
