Rails.application.routes.draw do
  root to: 'influencers#index'

  resources :influencers, only: :index
end
