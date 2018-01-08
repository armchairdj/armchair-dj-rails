# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "pages#index"

  get  "404" => "errors#not_found"
  get  "500" => "errors#internal_server_error"
  post "500" => "errors#internal_server_error"

  devise_scope :user do
    get    "register",            to: "users/registrations#new",     as: :new_user_registration
    post   "register",            to: "users/registrations#create",  as: :user_registration
    get    "cancel_registration", to: "users/registrations#cancel",  as: :cancel_user_registration
    get    "settings",            to: "users/registrations#edit"
    patch  "settings",            to: "users/registrations#update"
    put    "settings",            to: "users/registrations#update"
    delete "settings",            to: "users/registrations#destroy"

    get   "log_in",               to: "users/sessions#new",          as: :new_user_session
    post  "log_in",               to: "users/sessions#create",       as: :user_session
    match "log_out",              to: "users/sessions#destroy",      as: :destroy_user_session, via: Devise.sign_out_via
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
