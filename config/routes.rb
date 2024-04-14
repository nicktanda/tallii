Rails.application.routes.draw do
  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "create_session"
  get "/logout", to: "sessions#destroy", as: "destroy_session"

  get "/pets/:id", to: "pets#show", as: "pet"
  root "pets#index", as: "root"
end
