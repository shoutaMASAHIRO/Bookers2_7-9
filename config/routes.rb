Rails.application.routes.draw do
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search" => "searches#search"
  get "category_search" => "searches#category_search"


  devise_for :users

  resources :books, only: [:create, :index, :show, :destroy, :edit, :update] do
    resources :book_comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :following
      get :followers
      get :search_posts
    end
  end

  resources :relationships, only: [:create, :destroy]
  
  resources :rooms, only: [:show, :create]
  resources :messages, only: [:create]
  resources :groups, only: [:index, :show, :new, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
    get "new/event_notice" => "groups#new_event_notice"
    post "send/event_notice" => "groups#send_event_notice"
  end
end
