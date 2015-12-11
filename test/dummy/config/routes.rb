Rails.application.routes.draw do
  resources :protected_resources
  resource :current_user
  mount Knock::Engine => "/knock"
end
