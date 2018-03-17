# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "pages#index"

  #############################################################################
  # Style Guide.
  #############################################################################

  get "style_guide", to: "style_guides#index", as: "style_guides"

  get "style_guide/:template", to: "style_guides#show", as: "style_guides_item", constraints: {
    template: /button|form|form_error|headline|list|post|quotation|svg|text/
  }

  get "style_guide/flash/:flash_type", to: "style_guides#flash_message", as: "style_guides_flash", constraints: {
    flash_type: /alert|error|info|notice|success/
  }

  get "style_guide/error/:error_type", to: "style_guides#error_page", as: "style_guides_error", constraints: {
    error_type: /not_found|permission_denied|internal_server_error/
  }

  #############################################################################
  # Users.
  #############################################################################

  devise_scope :user do
    get    "register",          to: "users/registrations#new",             as: :new_user_registration
    get    "settings",          to: "users/registrations#edit",            as: :edit_user_registration
    post   "settings",          to: "users/registrations#create"
    match  "settings",          to: "users/registrations#update",          via: [:patch, :put]
    delete "settings",          to: "users/registrations#destroy"
    get    "settings/password", to: "users/registrations#edit_password"
    match  "settings/password", to: "users/registrations#update_password", via: [:patch, :put]
    delete "settings/cancel",   to: "users/registrations#destroy",         as: :destroy_user_registration

    get   "log_in",             to: "users/sessions#new",                  as: :new_user_session
    post  "log_in",             to: "users/sessions#create",               as: :user_session
    match "log_out",            to: "users/sessions#destroy",              as: :destroy_user_session, via: Devise.sign_out_via
  end

  devise_for :users, skip: [:sessions, :registrations], controllers: {
    confirmations: "users/confirmations",
    passwords:     "users/passwords",
    unlocks:       "users/unlocks"
  }

  #############################################################################
  # Artists.
  #############################################################################

  resources :artists

  #############################################################################
  # Albums.
  #############################################################################

  resources :albums

  #############################################################################
  # Songs.
  #############################################################################

  resources :songs

  #############################################################################
  # Posts.
  #############################################################################

  resources :posts
end
