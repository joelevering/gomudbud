Rails.application.routes.draw do
  root to: "rooms#index"

  resources :rooms
  resources :npcs
  # resources :players
end
