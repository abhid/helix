Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Sidekiq mounts
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # Root path
  root "pages#index"
  # Publicly available status page
  match "/status", to: "pages#status", as: "status", via: [:get]
  # Search controls
  match "/search", to: "search#search", as: "search", via: [:post, :get]
  # All the livelog routes
  match "/live", to: "logging#live", as: "livelog", via: [:get]
  match "/live_stream", to: "logging#live_stream", as: "livelog_stream", via: [:get, :post]
  # User management routes
  match "/login", to: "pages#login", as: "login", via: [:get, :post]
  match "/logout", to: "pages#logout", as: "logout", via: [:get]
  # Settings page
  match "/settings", to: "pages#settings", as: "settings", via: [:post, :get]
  # Resources
  resources :endpoints, :endpoint_groups, :network_devices, :network_device_groups, :authorization_profiles, :downloadable_acls
end
