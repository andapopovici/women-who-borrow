Rails.application.routes.draw do
  resources :books
  resources :tags
  root 'books#index'
end
