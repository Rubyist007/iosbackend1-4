Rails.application.routes.default_url_options[:host] = "localhost:3000"

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :dish_show do
    resources :dish, only: [:show, :update]
  end

  resources :restaurant, only: [:create, :show, :index, :update] do
    resources :dish, only: [:create, :index]
    collection do 
      get 'top_hundred'
      post 'top_ten_in_region'
      post 'near'
    end
  end

  concerns :dish_show

  resources :evaluation, only: [:create, :show, :index, :update] 

  resources :user, only: [:show, :index] do
    collection do 
      post 'news'
      post 'update'
      get 'thank'
    end
  end
  resources :relationship, only: [:create, :show, :destroy]
end
