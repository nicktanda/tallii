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
  
  get "/daycare_visits", to: "daycare_visits#index", as: "daycare_visits"
  get "/daycare_visits/:id", to: "daycare_visits#show", as: "daycare_visit"
  get "/create/daycare_visits", to: "daycare_visits#new", as: "new_daycare_visits"
  post "/create/daycare_visits", to: "daycare_visits#create", as: "create_daycare_visits"
  post "/update/daycare_visits/:id", to: "daycare_visits#update", as: "update_daycare_visits"
  delete "/daycare_visits/:id", to: "daycare_visits#delete", as: "delete_daycare_visits"

  get "/shop", to: "shop#shop", as: "shop"
  get "/shop/categories/:id", to: "shop#category", as: "category"
  get "/shop/products/:id", to: "shop#product", as: "product"
  get "/shop/products/:id/review", to: "shop#review", as: "new_review"
  post "/shop/products/:id/review", to: "shop#create_review", as: "create_review"
  post "/shop/products/:id/add_to_cart", to: "shop#add_to_cart", as: "add_to_cart"
  get "/shop/cart", to: "shop#cart", as: "cart"

  post "/orders", to: "orders#create", as: "create_order"
  get "/orders/:id/pay", to: "payments#pay", as: "pay"
  get "/orders/:id", to: "orders#summary", as: "order_summary"
  post "webhooks/payment", to: "webhooks#payment"

  root "pets#index", as: "root"
end
