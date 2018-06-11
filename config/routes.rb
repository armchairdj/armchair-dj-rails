# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  #############################################################################
  # CONCERNS.
  #############################################################################

  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end

  #############################################################################
  # USERS.
  #############################################################################

  devise_for :users, skip: [:sessions, :registrations], controllers: {
    confirmations: "users/confirmations",
    passwords:     "users/passwords",
    unlocks:       "users/unlocks"
  }

  devise_scope :user do
    get    "log_in",            to: "users/sessions#new",                  as: :new_user_session
    post   "log_in",            to: "users/sessions#create",               as: :user_session
    match  "log_out",           to: "users/sessions#destroy",              as: :destroy_user_session, via: Devise.sign_out_via

    get    "register",          to: "users/registrations#new",             as: :new_user_registration
    post   "register",          to: "users/registrations#create"

    get    "settings",          to: "users/registrations#edit",            as: :edit_user_registration
    match  "settings",          to: "users/registrations#update",          via: [:patch, :put]
    delete "settings",          to: "users/registrations#destroy"

    get    "settings/password", to: "users/registrations#edit_password"
    match  "settings/password", to: "users/registrations#update_password", via: [:patch, :put]

    get    "profile/:username", to: "users/registrations#profile",         as: :user_profile
  end

  #############################################################################
  # PAGES.
  #############################################################################

  get "about",   to: "pages#about"
  get "credits", to: "pages#credits"
  get "privacy", to: "pages#privacy"
  get "terms",   to: "pages#terms"

  #############################################################################
  # ERRORS.
  #############################################################################

  get "403", to: "errors#permission_denied"
  get "404", to: "errors#not_found"
  get "422", to: "errors#bad_request"
  get "500", to: "errors#internal_server_error"

  #############################################################################
  # ADMIN.
  #############################################################################

  namespace :admin do
    resources :articles,   concerns: :paginatable
    resources :creators,   concerns: :paginatable
    resources :mixtapes,   concerns: :paginatable
    resources :reviews,    concerns: :paginatable
    resources :roles,      concerns: :paginatable
    resources :tags,       concerns: :paginatable
    resources :users,      concerns: :paginatable
    resources :works,      concerns: :paginatable

    resources :playlists, concerns: :paginatable do
      member do
        post :reorder_playlistings
      end
    end
  end

  #############################################################################
  # STYLE GUIDES.
  #############################################################################

  get "style_guide", to: "style_guides#index", as: "style_guides"

  get "style_guide/:template", to: "style_guides#show", as: "style_guides_item", constraints: {
    template: /button|form|form_error|headline|list|post|quotation|tabs|svg|text/
  }

  get "style_guide/flash/:flash_type", to: "style_guides#flash_message", as: "style_guides_flash", constraints: {
    flash_type: /alert|error|info|notice|success/
  }

  get "style_guide/error/:error_type", to: "style_guides#error_page", as: "style_guides_error", constraints: {
    error_type: /bad_request|internal_server_error|not_found|permission_denied/
  }

  #############################################################################
  # POSTS.
  #############################################################################

  scope format: true, constraints: { format: "rss" } do
    get "/feed", to: "articles#feed"
  end

  #############################################################################
  # REVIEWS.
  #############################################################################

  resources :reviews, only: [:index, :show], concerns: :paginatable

  #############################################################################
  # MIXTAPES.
  #############################################################################

  resources :mixtapes, only: [:index, :show], concerns: :paginatable

  #############################################################################
  # PLAYLISTS.
  #############################################################################

  resources :playlists, only: [:index, :show], concerns: :paginatable

  #############################################################################
  # CREATORS.
  #############################################################################

  resources :creators, only: [:index, :show], concerns: :paginatable

  #############################################################################
  # WORKS.
  #############################################################################

  resources :works, only: [:index, :show], concerns: :paginatable

  #############################################################################
  # TAGS.
  #############################################################################

  resources :tags, only: [:index, :show], concerns: :paginatable


  resources :articles, only: [:index, :show], concerns: :paginatable, path: "/"
end
