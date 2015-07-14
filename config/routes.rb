Knock::Engine.routes.draw do
  post 'auth_token' => 'auth_token#create'
end
