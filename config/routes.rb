Rails.application.routes.draw do
  resources :books
  resources :tags
  resources :users
  root 'books#index'
end
