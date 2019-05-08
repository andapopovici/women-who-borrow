Rails.application.routes.draw do
  resources :books do
    resources :reservations
  end

  resources :tags

  resources :users

  root 'books#index'
end
