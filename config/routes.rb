Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/microposts', to: 'microposts#destroy'
  delete '/favorite_relationships', to: 'favorite_relationships#destroy'

  resources :users do
    member do
      get :following, :followers, :favorites
    end
  end
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
  resources :favorite_relationships, only: %i(create destroy)
end
