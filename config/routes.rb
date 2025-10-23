Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    namespace :dashboard do
      resources :movies, except: [ :show ] do
        collection do
          post :fetch_movie_data_ai
        end
      end
      resource :profile, only: [ :edit, :update ]
    end
  end

  root "movies#index"

  resources :movies, only: [ :index, :show ] do
    resources :comments, only: [ :create ]
  end
end
