Rails.application.routes.draw do
  get "movies/index"
  get "movies/show"
  devise_for :users
 
  root 'movies#index'
  resources :movies, only: [:index, :show]
end
