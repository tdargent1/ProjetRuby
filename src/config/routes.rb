Rails.application.routes.draw do
  root 'films#index'

  devise_for :users

  resources :films
  resources :categories
  resources :comments
  resources :posts
  
  resources :users, only: [:edit] do
    member do
      put 'accept_request'
      put 'refuse_request'
    end
  end
end
