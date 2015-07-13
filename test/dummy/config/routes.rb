Rails.application.routes.draw do
  resources :protected_resources
  mount Simsim::Engine => "/simsim"
end
