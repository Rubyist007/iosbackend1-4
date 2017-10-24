Rails.application.routes.default_url_options[:host] = "localhost:3000"

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'user', controllers: {registrations: 'override_device_controller/registrations', sessions: 'override_device_controller/sessions' }, skip: [:omniauth, :omniauth_callbacks]

  concern :dish_show do
    resources :dish, only: [:show, :update]
  end

  resources :restaurant, only: [:create, :show, :index, :update] do
    resources :dish, only: [:create, :index]
    collection do 
      get 'all_restaurant_in_city'
      get 'top_hundred'
      get 'top_ten_in_city'
      get 'near'
    end
  end

  concerns :dish_show

  resources :evaluation, only: [:create, :show, :update] do
    collection do 
      get "my"
    end
  end

  resources :user, only: [:show, :index] do
    collection do 
      get 'feed'
      get 'thank'
      post 'report'
    end
  end
  #resources :relationship, only: [:create, :show, :destroy]
end
