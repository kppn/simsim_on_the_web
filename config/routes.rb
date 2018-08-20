Rails.application.routes.draw do
  root :to => 'top#index'

  devise_for :users, :controllers => {
    #:sessions      => "devise_custom/sessions",
    #:registrations => "devise_custom/registrations",
    #:passwords     => "devise_custom/passwords",
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords",
  }

  resources :environments
  resources :peers
  resources :configs
  resources :extras
  resources :scenarios
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
