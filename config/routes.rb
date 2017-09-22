Rails.application.routes.default_url_options[:host] = "localhost:3000"

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/user'

  mount_devise_token_auth_for 'Admin', at: 'auth/admin'
  as :admin do
    # Define routes for Admin within this block.
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :dish_show do
    resources :dish, only: [:show]
  end

  resources :restaurant, only: [:create, :show, :index] do
    resources :dish, only: [:create, :index]
    collection do 
      get 'top_hundred'
      post 'top_ten_in_region'
      post 'near'
    end
  end

  concerns :dish_show

  resources :evaluation, only: [:create, :show, :index]
  resources :user, only: [:show, :index] do
    collection do 
      post 'news'
      get 'thank'
    end
  end
  resources :relationship, only: [:create, :show, :destroy]
end
