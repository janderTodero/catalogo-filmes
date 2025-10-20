Rails.application.routes.draw do  
  devise_for :users
 
  root 'movies#index'
  
  resources :movies, only: [:index, :show] do
    resources :comments, only: [:create]
  end
end
