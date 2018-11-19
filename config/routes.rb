Rails.application.routes.draw do
  root to: "rooms#index"

  resources :rooms
  resources :exits
  resources :npcs
  resources :behaviors
  # resources :players
end
