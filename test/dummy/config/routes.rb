Rails.application.routes.draw do
  resources :protected_resources
  resource :current_user

  resources :admin_protected

  mount Knock::Engine => "/knock"
end
