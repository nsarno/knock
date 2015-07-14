Rails.application.routes.draw do
  resources :protected_resources
  mount Knock::Engine => "/knock"
end
