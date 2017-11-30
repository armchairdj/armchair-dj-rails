# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "pages#index"

  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"
  post "/500" => "errors#internal_server_error"

  resources :artists
  resources :albums
  resources :songs
  resources :posts
end
