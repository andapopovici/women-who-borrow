Rails.application.routes.draw do
	resources :books

	resources :tags

	resources :users do 
		collection do
			get :search
		end
	end

	root 'books#index'
end
