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
    resources :schedules, only: [:index]
    post "schedules/calendar"
    post "schedules", to: "schedules#schedules", as: "schedules_date"
  end
  resources :schedules, only: [:show, :edit, :update, :destroy, :new, :create]

  resources :favorites, only: [:index, :create, :destroy]

  resources :messages do
    member do
      get "receivers"
      patch "trash"
      patch "restore"
    end
  end

  post "search_users", to: "search_users#search_users", as: "search_users"

  resources :bulletin_boards


  resource :comments, only: [:create, :destroy]

  root to: "homes#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get "*not_found", to: "application#routing_error"
  # match '*unmatched_route', :to => 'application#raise_not_found!', :via => :all
end
