Rails.application.routes.draw do
  resources :posts
  resources :topics

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
