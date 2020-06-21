Rails.application.routes.draw do
  root 'films#index'

  devise_for :users

  resources :films do 
    member do
      put 'add'
    end
  end

  resources :categories
  
  resources :users, only: [:edit, :destroy, :index] do
    member do
      put 'request_film'
      put 'accept_request'
      put 'refuse_request'
      put 'follow'
      put 'unfollow'
    end
  end
end
