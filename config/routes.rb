Rails.application.routes.draw do
  get "/sign_up", to: "users#new", as: "new_user"
  post "/sign_up", to: "users#create", as: "create_user"
  get "/landing", to: "sessions#landing", as: "landing"

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "create_session"
  get "/logout", to: "sessions#destroy", as: "destroy_session"

  get "/pets/:id", to: "pets#show", as: "pet"

  get "/shop", to: "shop#shop", as: "shop"
  root "pets#index", as: "root"
end
