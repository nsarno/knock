Rails.application.routes.draw do
  post 'admin_user_token' => 'admin_user_token#create'
  post 'user_token' => 'user_token#create'
  post 'admin_token' => 'admin_token#create'

  resources :user_protected
  resources :admin_protected
  resources :admin_user_protected
end
