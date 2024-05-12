Rails.application.routes.draw do
  get "/sign_up", to: "users#new", as: "new_user"
  post "/sign_up", to: "users#create", as: "create_user"
  get "/landing", to: "sessions#landing", as: "landing"

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "create_session"
  get "/logout", to: "sessions#destroy", as: "destroy_session"

  get "/pets/:id", to: "pets#show", as: "pet"
  get "/create/pets", to: "pets#new", as: "new_pet"
  post "/create/pets", to: "pets#create", as: "create_pet"

  get "/grooms", to: "grooms#index", as: "grooms"
  get "/grooms/:id", to: "grooms#show", as: "groom"
  get "/create/grooms", to: "grooms#new", as: "new_groom"
  post "/create/grooms", to: "grooms#create", as: "create_groom"
  post "/update/grooms/:id", to: "grooms#update", as: "update_groom"
  delete "/grooms/:id", to: "grooms#delete", as: "delete_groom"

  get "/shop", to: "shop#shop", as: "shop"
  root "pets#index", as: "root"
end
