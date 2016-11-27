Rails.application.routes.draw do
  post 'admin_token' => 'admin_token#create'
  post 'vendor_token' => 'vendor_token#create'

  resources :protected_resources
  resource :current_user

  resources :admin_protected
  resources :composite_name_entity_protected
  resources :vendor_protected
  resources :custom_unauthorized_entity

  namespace :v1 do
    resources :test_namespaced
  end

  mount Knock::Engine => "/knock"
end
