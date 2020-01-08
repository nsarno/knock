Rails.application.routes.draw do
  post 'admin_token' => 'admin_token#create'
  post 'vendor_token' => 'vendor_token#create'

  resource :current_user

  resources :admin_protected
  resources :soft_admin, only: [:index]
  resources :composite_name_entity_protected
  resources :custom_unauthorized_entity
  resources :guest_protected
  resources :protected_resources
  resources :vendor_protected
  resources :admin_custom_auth_strict, only: [:index]
  resources :admin_custom_auth_soft, only: [:index]
  
  namespace :v1 do
    resources :test_namespaced
  end
end
