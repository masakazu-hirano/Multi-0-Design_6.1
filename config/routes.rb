Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'users/recruiter_sign_in', to: 'users/recruiter_sessions#recruiter_login'
    post 'users/recruiter_sign_in', to: 'users/recruiter_sessions#recruiter_login'
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end
  root to: 'influencers#index'

  resources :influencers, only: :index
  resources :youtube_videos, only: [:index, :new]
end
