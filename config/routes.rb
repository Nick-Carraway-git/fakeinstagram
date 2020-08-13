Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations' }
  resources :users, only: [:show]
  resources :microposts
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy, :index]
  resources :notifications, only: [:index]
  delete '/notifications', to: 'notifications#destroy_all'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/results',  to: 'static_pages#result'
  get '/rules', to: 'static_pages#rule'

  resources :users do
    member do
      get :following, :followers
    end
  end
end
