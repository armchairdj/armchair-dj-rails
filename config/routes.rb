# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :albums
  resources :songs
  resources :artists

  root "artists#index"
end
