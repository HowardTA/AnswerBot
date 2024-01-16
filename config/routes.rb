Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get    "posts" => "posts#index", as: :posts
  get    "posts/new" => "posts#new", as: :new_post
  post   "posts" => "posts#create"
  get    "posts/:id" => "posts#show", as: :post
  get    "posts/:id/edit" => "posts#edit", as: :edit_post
  patch  "posts/:id" => "posts#update"
  delete "posts/:id" => "posts#destroy"

  get "run" => "run#app", as: :run_app

  get "main" => "main#index", as: :main
  
  root to: "main#index"

  # Defines the root path route ("/")
  # root "posts#index"
end
