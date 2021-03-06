# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  #############################################################################
  # CONCERNS.
  #############################################################################

  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end

  concern :autosaveable do
    match "autosave", on: :member, action: :autosave, via: [:patch, :put]
  end

  concern :previewable do
    match "preview", on: :member, action: :preview, via: [:get]
  end

  #############################################################################
  # USERS.
  #############################################################################

  devise_for :users, skip: [:sessions, :registrations], controllers: {
    confirmations: "users/confirmations",
    passwords:     "users/passwords",
    unlocks:       "users/unlocks"
  }

  # Custom URLs for Devise login and registration actions
  devise_scope :user do
    get    "log_in",  to: "users/sessions#new",     as: :new_user_session
    post   "log_in",  to: "users/sessions#create",  as: :user_session
    match  "log_out", to: "users/sessions#destroy", as: :log_out, via: Devise.sign_out_via

    get    "register", to: "users/registrations#new",   as: :new_user_registration
    post   "register", to: "users/registrations#create"

    get    "settings", to: "users/registrations#edit",   as: :edit_user_registration
    match  "settings", to: "users/registrations#update", via: [:patch, :put]
    delete "settings", to: "users/registrations#destroy"

    get    "settings/password", to: "users/registrations#edit_password"
    match  "settings/password", to: "users/registrations#update_password", via: [:patch, :put]
  end

  # Public profile.
  get "profile/:id", to: "users#show", as: :user

  #############################################################################
  # PAGES.
  #############################################################################

  get ":template", to: "pages#show", as: :static_page, constraints: {
    template: /about|credits|privacy|terms|contact/
  }

  #############################################################################
  # ERRORS.
  #############################################################################

  get "403", to: "errors#permission_denied"
  get "404", to: "errors#not_found"
  get "422", to: "errors#bad_request"
  get "500", to: "errors#internal_server_error"

  #############################################################################
  # POSTS.
  #############################################################################

  scope module: :posts do
    # Indices.
    resources :posts,    only: [:index], concerns: :paginatable, path: "/"
    resources :articles, only: [:index], concerns: :paginatable
    resources :reviews,  only: [:index], concerns: :paginatable
    resources :mixtapes, only: [:index], concerns: :paginatable

    # Permalinks.
    get "articles/*slug", to: "articles#show", as: :article
    get "reviews/*slug",  to: "reviews#show",  as: :review
    get "mixtapes/*slug", to: "mixtapes#show", as: :mixtape

    # Syndication.
    scope format: true, constraints: { format: "rss" } do
      get "feed", to: "posts#feed"
    end
  end

  #############################################################################
  # ADMIN.
  #############################################################################

  get "/admin", to: redirect("/admin/reviews", status: 302)

  namespace :admin do
    scope module: :posts do
      resources :articles, concerns: [:paginatable, :previewable, :autosaveable]
      resources :reviews,  concerns: [:paginatable, :previewable, :autosaveable]
      resources :mixtapes, concerns: [:paginatable, :previewable, :autosaveable]
    end

    resources :users,    concerns: :paginatable
    resources :tags,     concerns: :paginatable
    resources :creators, concerns: :paginatable
    resources :aspects,  concerns: :paginatable
    resources :roles,    concerns: :paginatable

    resources :playlists, concerns: :paginatable do
      member { post :reorder_tracks }
    end

    resources :works, concerns: :paginatable do
      member { post :reorder_credits }
    end
  end

  #############################################################################
  # STYLE GUIDES.
  #############################################################################

  get "style_guide", to: "style_guides#index", as: :style_guides

  get "style_guide/:template", to: "style_guides#show", as: :style_guides_item, constraints: {
    template: /button|form|form_error|headline|list|post|quotation|tabs|tables|svg|text/
  }

  get "style_guide/flash/:flash_type", to: "style_guides#flash_message", as: :style_guides_flash,
    constraints: { flash_type: /alert|error|info|notice|success/ }

  get "style_guide/error/:error_type", to: "style_guides#error_page", as: :style_guides_error,
    constraints: { error_type: /bad_request|internal_server_error|not_found|permission_denied/ }
end
