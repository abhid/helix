Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root "pages#index"
  match "/status", to: "pages#status", as: "status", via: [:get]
  match "/search", to: "search#search", as: "search", via: [:post, :get]
  resources :endpoints, :endpoint_groups, :network_devices, :network_device_groups, :authorization_profiles, :downloadable_acls
end
