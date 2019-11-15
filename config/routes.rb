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
  get "/network_devices/router.db", to: "network_devices#oxidized_conf"
  get "/network_device_groups/:id/router.db", to: "network_device_groups#oxidized_conf"

  # Resources
  resources :endpoints, :endpoint_groups, :network_devices, :network_device_groups, :authorization_profiles, :downloadable_acls

  # Async resources
  get "/endpoint/show/infoblox", to: "endpoints#show_infoblox", as: "endpoint_infoblox"
  get "/endpoint/show/ise_mnt", to: "endpoints#show_ise_mnt", as: "endpoint_ise_mnt"
  get "/endpoint/show/ise_ers", to: "endpoints#show_ise_ers", as: "endpoint_ise_ers"
  get "/endpoint/show/prime", to: "endpoints#show_prime", as: "endpoint_prime"
end
