Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  post 'admin_token' => 'admin_token#create'
  resources :user_protected
  resources :admin_protected
end
