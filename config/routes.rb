Rails.application.routes.draw do
  # カンバンボード表示用のルート (1ユーザー1ボードなので単数リソース)
  resource :board, only: [:show]

  # レーンとカードのCRUD操作用のルート
  resources :lanes, only: [:create, :update, :destroy] do
    resources :cards, only: [:new, :create] # :new を追加
  end

  resources :cards, only: [:update, :destroy] do
    member do
      patch :move
    end
  end

  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy" => "likes#destroy"

  get "users/search" => "users#search"
  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"
  get "users/:id/likes" => "users#likes"
  post "users/:id/discard" => "users#discard"

  get "posts/index" => "posts#index"
  get "posts/new" => "posts#new"
  # get "posts/new" => "posts#new_fixed"
  get "posts/:id" => "posts#show"
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  get "posts/:id/word_cloud" => "posts#word_cloud"
  # get "posts/:id/edit" => "posts#edit_fixed"
  post "posts/:id/update" => "posts#update"
  get "posts/:id/destroy" => "posts#destroy"

  get 'schedules/index', to: 'schedules#index', as: 'schedules_index'
  get "schedules/new" => "schedules#new"
  # get "schedules/new" => "schedules#new_fixed"
  get "schedules/:id" => "schedules#show"
  post "schedules/create" => "schedules#create"
  get "schedules/:id/edit" => "schedules#edit"
  get 'schedules/date/:date/edit', to: 'schedules#edit_by_date', as: :edit_schedule_by_date
  post 'schedules/date/:date/update', to: 'schedules#update_by_date'
  # post "schedules/:id/update" => "schedules#update"
  get "schedules/:id/destroy" => "schedules#destroy"

  resources :memos

  get "/" => "home#top"
  get "about" => "home#about"

  resources :tasks do
    collection do
      get 'gantt'
    end
  end

  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end
