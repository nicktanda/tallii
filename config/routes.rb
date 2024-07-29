Rails.application.routes.draw do
  # MOBILE APP ROUTES
  get "/sign_up", to: "users#new", as: "new_user"
  post "/sign_up", to: "users#create", as: "create_user"
  patch "/update/:id", to: "users#update", as: "update_user"
  delete "/delete/:id", to: "users#delete", as: "delete_user"
  get "/reset_password", to: "users#reset_password", as: "reset_password"
  post "/update_password", to: "users#update_password", as: "update_password"

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "create_session"
  get "/logout", to: "sessions#destroy", as: "destroy_session"
  post "/set_current_pet/:id", to: "sessions#set_current_pet", as: "set_current_pet"

  get "/pets/:id", to: "pets#show", as: "pet"
  get "/pets/:id/pictures", to: "pets#pictures", as: "pet_pictures"
  post "/create/pets/:id/images", to: "pets#upload_new_image", as: "upload_new_image"
  patch "/update/pets/:id", to: "pets#update", as: "update_pet"
  delete "/pets/:id", to: "pets#delete", as: "delete_pet"
  delete "/pets/:id/images/:image_id", to: "pets#delete_image", as: "delete_image"

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

  get "/orders", to: "orders#index", as: "orders"
  post "/orders", to: "orders#create", as: "create_order"
  get "/orders/:id/pay", to: "payments#pay", as: "pay"
  post "/webhooks/payment", to: "payments#webhook"

  get "/settings", to: "settings#index", as: "settings"

  get "/settings/pet_profiles", to: "settings#pet_profiles", as: "pet_profiles"
  get "/settings/pet_profiles/:id", to: "settings#pet_profile", as: "pet_profile"

  get "/settings/pet_selection", to: "settings#pet_selection", as: "pet_selection"
  post "/settings/pet_selection", to: "settings#switch_pet", as: "switch_pet"

  get "/settings/user_profile", to: "settings#user_profile", as: "user_profile"
  post "/settings/user_profile/edit", to: "settings#update_user_profile", as: "update_user_profile"

  get "/onboarding/pets", to: "pets/onboarding#new", as: "new_pet_onboarding"
  get "/onboarding/pets/:id/species", to: "pets/onboarding#species", as: "pet_species_onboarding"
  post "/onboarding/pets/:id/species", to: "pets/onboarding#update_species", as: "update_pet_species_onboarding"
  get "/onboarding/pets/:id/name", to: "pets/onboarding#name", as: "pet_name_onboarding"
  post "/onboarding/pets/:id/name", to: "pets/onboarding#update_name", as: "update_pet_name_onboarding"
  get "/onboarding/pets/:id/gender", to: "pets/onboarding#gender", as: "pet_gender_onboarding"
  post "/onboarding/pets/:id/gender", to: "pets/onboarding#update_gender", as: "update_pet_gender_onboarding"
  get "/onboarding/pets/:id/dob", to: "pets/onboarding#dob", as: "pet_dob_onboarding"
  post "/onboarding/pets/:id/dob", to: "pets/onboarding#update_dob", as: "update_pet_dob_onboarding"
  get "/onboarding/pets/:id/weight", to: "pets/onboarding#weight", as: "pet_weight_onboarding"
  post "/onboarding/pets/:id/weight", to: "pets/onboarding#update_weight", as: "update_pet_weight_onboarding"
  get "/onboarding/pets/:id/breed", to: "pets/onboarding#breed", as: "pet_breed_onboarding"
  post "/onboarding/pets/:id/breed", to: "pets/onboarding#update_breed", as: "update_pet_breed_onboarding"
  get "/onboarding/pets/:id/health_conditions", to: "pets/onboarding#health_conditions", as: "pet_health_conditions_onboarding"
  post "/onboarding/pets/:id/health_conditions", to: "pets/onboarding#update_health_conditions", as: "update_pet_health_conditions_onboarding"
  get "/onboarding/pets/:id/images", to: "pets/onboarding#images", as: "pet_images_onboarding"
  post "/onboarding/pets/:id/images", to: "pets/onboarding#upload_image", as: "upload_pet_image_onboarding"
  get "/onboarding/pets/:id/complete", to: "pets/onboarding#complete", as: "complete_onboarding"
  post "/onboarding/pets/:id/create", to: "pets/onboarding#create_pet", as: "create_pet_onboarding"

  root "pets#current_pet_profile", as: "root"

  # DESKTOP APP ROUTES
  get "/desktop/dashboard", to: "desktop/dashboard#index", as: "desktop_dashboard"

  get "/desktop/grooms", to: "desktop/grooms#index", as: "desktop_grooms"
  get "/desktop/grooms/new", to: "desktop/grooms#new", as: "desktop_grooms_new"

  get "/desktop/daycare_visits", to: "desktop/daycare_visits#index", as: "desktop_daycare_visits"
  get "/desktop/daycare_visits/new", to: "desktop/daycare_visits#new", as: "desktop_daycare_visits_new"

  get "/desktop/users", to: "desktop/users#index", as: "desktop_users"
  get "/desktop/users/new", to: "desktop/users#new", as: "desktop_users_new"
  post "/desktop/users/create", to: "desktop/users#create", as: "desktop_users_create"
  get "/desktop/users/:id", to: "desktop/users#show", as: "desktop_user"
  get "/desktop/users/:id/edit", to: "desktop/users#edit", as: "desktop_user_edit"
  patch "/desktop/users/:id/update", to: "desktop/users#update", as: "desktop_user_update"
  delete "/desktop/users/:id/delete", to: "desktop/users#delete", as: "desktop_user_delete"

  get "/desktop/retail", to: "desktop/retail#index", as: "desktop_retail"

  get "/desktop/users/:id/pets/new", to: "desktop/pets#new", as: "desktop_pets_new"
  post "/desktop/pets/create", to: "desktop/pets#create", as: "desktop_pets_create"
  get "/desktop/pets/:id", to: "desktop/pets#show", as: "desktop_pets"

  get "/desktop/reports", to: "desktop/reports#index", as: "desktop_reports"

  get "/desktop/settings", to: "desktop/settings#index", as: "desktop_settings"
end
