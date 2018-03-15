# For details on the DSL available within this file, see
# http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "pages#index"

  #############################################################################
  # Style Guide.
  #############################################################################

  get "style_guide",                       to: "style_guides#index",                 as: "style_guides"

  get "style_guide/list",                  to: "style_guides#list",                  as: "style_guides_list"
  get "style_guide/post",                  to: "style_guides#post",                  as: "style_guides_post"

  get "style_guide/button",                to: "style_guides#button",                as: "style_guides_button"
  get "style_guide/form",                  to: "style_guides#form",                  as: "style_guides_form"
  get "style_guide/form_with_errors",      to: "style_guides#form_with_errors",      as: "style_guides_form_with_errors"

  get "style_guide/flash_alert",           to: "style_guides#flash_alert",           as: "style_guides_flash_alert"
  get "style_guide/flash_error",           to: "style_guides#flash_error",           as: "style_guides_flash_error"
  get "style_guide/flash_info",            to: "style_guides#flash_info",            as: "style_guides_flash_info"
  get "style_guide/flash_notice",          to: "style_guides#flash_notice",          as: "style_guides_flash_notice"
  get "style_guide/flash_success",         to: "style_guides#flash_success",         as: "style_guides_flash_success"

  get "style_guide/internal_server_error", to: "style_guides#internal_server_error", as: "style_guides_internal_server_error"
  get "style_guide/not_found",             to: "style_guides#not_found",             as: "style_guides_not_found"
  get "style_guide/permission_denied",     to: "style_guides#permission_denied",     as: "style_guides_permission_denied"

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
