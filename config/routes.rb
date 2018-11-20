Rails.application.routes.draw do
  root to: "rooms#index"

  resources :rooms
  resources :exits
  resources :npcs
  resources :behaviors do
    resources :actions, controller: "behavior_actions"
  end
  resources :combat_behaviors
  # resources :players
end
