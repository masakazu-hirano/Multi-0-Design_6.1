Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/recruiter_sign_in', to: 'users/recruiter_sessions#recruiter_login'
  end
  root to: 'influencers#index'

  resources :influencers, only: :index
  resources :youtube_videos, only: [:index, :new]
end
