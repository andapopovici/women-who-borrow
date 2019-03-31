Rails.application.routes.draw do
  resources :books do
    resources :reservations, only: [:new, :create, :show, :destroy]
  end

  resources :tags

  resources :users

  root 'books#index'
end
