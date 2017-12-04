Rails.application.routes.default_url_options[:host] = "localhost:3000"

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'user', controllers: {
    registrations: 'override_device_controller/registrations', 
    sessions: 'override_device_controller/sessions',
    omniauth_callbacks: 'override_device_controller/omniauth_callbacks',
    passwords: 'override_device_controller/passwords'
  }

  concern :dish_show do
    resources :dish, only: [:show, :update]
  end

  resources :restaurant, only: [:create, :show, :index, :update] do
    resources :dish, only: [:create, :index]
    collection do 
      get 'all_city'
      get 'all_restaurant_in_city'
      get 'top_hundred'
      get 'top_ten_in_city'
      get 'near'
    end
  end

  concerns :dish_show

  resources :evaluation, only: [:create, :show, :update, :destroy] do
    get "my", on: :collection
    get "user", on: :member
  end

  resources :user, path: 'users', only: [:show, :index, :update] do
    collection do 
      get 'feed'
      get 'thank'
      get 'resend_confirmation'
    end

    member do 
      post 'ban'
    end
  end

  resources :report, only: [:show, :create, :index, :destroy]
  #resources :relationship, only: [:create, :show, :destroy]
end
