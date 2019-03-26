Rails.application.routes.draw do
    resources :books do
    end

    resources :tags

    resources :users

    root 'books#index'
end
