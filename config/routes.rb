LearnRails::Application.routes.draw do
  get "static_pages/home"
  get "static_pages/about"
  get "static_pages/help"
  resources :contacts, only: [:new, :create]
  resources :visitors, only: [:new, :create]
  root to: 'visitors#new'
end