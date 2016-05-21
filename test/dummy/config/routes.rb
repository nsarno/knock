Rails.application.routes.draw do
  resources :protected_resources
  resource :current_user

  resources :admin_protected

  post 'admin_token' => 'admin_token#create'

  mount Knock::Engine => "/knock"
end
