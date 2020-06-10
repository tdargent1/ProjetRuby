Rails.application.routes.draw do
  root 'films#index'

  resources :films
  

  devise_for :users
  resources :categories
  resources :comments
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts # localhost:3000/posts
end
