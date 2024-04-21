  # config/routes.rb
  Rails.application.routes.draw do
    namespace :api do
      resources :features, only: [:index] do
        resources :comments, only: [:create]
        get 'comments_count', to: 'features#comments_count'
      end
    end
  end
