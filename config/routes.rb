Rails.application.routes.draw do
	resources :books do 
		put :reserve, on: :member
	end

	resources :tags

	resources :users

	root 'books#index'
end
