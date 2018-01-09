# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "pages#index"

  get  "404" => "errors#not_found"
  get  "500" => "errors#internal_server_error"
  post "500" => "errors#internal_server_error"

  devise_scope :user do
    get    "register",          to: "users/registrations#new",             as: :new_user_registration
    get    "register/cancel",   to: "users/registrations#cancel",          as: :cancel_user_registration
    get    "settings",          to: "users/registrations#edit",            as: :edit_user_registration
    post   "settings",          to: "users/registrations#create"
    match  "settings",          to: "users/registrations#update",          via: [:patch, :put]
    delete "settings",          to: "users/registrations#destroy"
    get    "settings/password", to: "users/registrations#edit_password"
    match  "settings/password", to: "users/registrations#update_password", via: [:patch, :put]

    get   "log_in",             to: "users/sessions#new",                  as: :new_user_session
    post  "log_in",             to: "users/sessions#create",               as: :user_session
    match "log_out",            to: "users/sessions#destroy",              as: :destroy_user_session, via: Devise.sign_out_via
  end

  devise_for :users, skip: [:sessions, :registrations], controllers: {
    confirmations: "users/confirmations",
    passwords:     "users/passwords",
    unlocks:       "users/unlocks"
  }

  resources :artists
  resources :albums
  resources :songs
  resources :posts
end
