Rails.application.routes.draw do
  devise_for :users
  root to: 'influencers#index'

  resources :influencers, only: :index
end
