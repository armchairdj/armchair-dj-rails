# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :artists
  resources :albums
  resources :songs
  resources :posts

  root "posts#index"
end
