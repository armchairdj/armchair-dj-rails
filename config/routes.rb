# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users
  root "pages#index"

  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"
  post "/500" => "errors#internal_server_error"

  resources :artists
  resources :albums
  resources :songs
  resources :posts

  # devise_for :users, controllers: {
  #   confirmations: "users/confirmations",
  #   passwords:     "users/passwords",
  #   registrations: "users/registrations",
  #   sessions:      "users/sessions",
  #   unlocks:       "users/sessions"
  # }
end
