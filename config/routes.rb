Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurant, only: [:create, :show, :index]
  resources :menu, only: [:create, :show]
  resources :dish, only: [:create, :show, :index]
  resources :evaluation, only: [:create, :show, :index]
end
