Rails.application.routes.draw do
  authenticate :user do
    namespace :dashboard do
      resources :movies
    end
  end
  devise_for :users

  root "movies#index"

  resources :movies, only: [ :index, :show ] do
    resources :comments, only: [ :create ]
  end
end
