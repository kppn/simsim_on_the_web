Rails.application.routes.draw do
  resources :environments
  resources :users
  resources :peers
  resources :configs
  resources :extras
  resources :scenarios
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
