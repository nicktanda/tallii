Rails.application.routes.draw do
  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"

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

  get "/pets/current_pet_profile", to: "pets#current_pet_profile", as: "current_pet_profile"
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
  patch "/update/grooms/:id", to: "grooms#update", as: "update_groom"
  patch "/confirm/grooms/:id", to: "grooms#confirm", as: "confirm_groom"
  delete "/grooms/:id", to: "grooms#delete", as: "delete_groom"
  
  get "/daycare_visits", to: "daycare_visits#index", as: "daycare_visits"
  get "/daycare_visits/:id", to: "daycare_visits#show", as: "daycare_visit"
  get "/create/daycare_visits", to: "daycare_visits#new", as: "new_daycare_visits"
  post "/create/daycare_visits", to: "daycare_visits#create", as: "create_daycare_visits"
  patch "/update/daycare_visits/:id", to: "daycare_visits#update", as: "update_daycare_visits"
  patch "/confirm/daycare_visits/:id", to: "daycare_visits#confirm", as: "confirm_daycare_visits"
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

  get "/onboarding/user", to: "onboarding_users#new", as: "new_user_onboarding"
  get "/onboarding/user/:id/email", to: "onboarding_users#email", as: "user_email_onboarding"
  post "/onboarding/user/:id/email", to: "onboarding_users#update_email", as: "update_user_email_onboarding"
  get "/onboarding/user/:id/password", to: "onboarding_users#password", as: "user_password_onboarding"
  post "/onboarding/user/:id/password", to: "onboarding_users#update_password", as: "update_user_password_onboarding"
  get "/onboarding/user/:id/name", to: "onboarding_users#name", as: "user_name_onboarding"
  post "/onboarding/user/:id/name", to: "onboarding_users#update_name", as: "update_user_name_onboarding"
  get "/onboarding/user/:id/phone", to: "onboarding_users#phone", as: "user_phone_onboarding"
  post "/onboarding/user/:id/phone", to: "onboarding_users#update_phone", as: "update_user_phone_onboarding"
  get "/onboarding/user/:id/address", to: "onboarding_users#address", as: "user_address_onboarding"
  post "/onboarding/user/:id/address", to: "onboarding_users#update_address", as: "update_user_address_onboarding"
  get "/onboarding/user/:id/organisation", to: "onboarding_users#organisation", as: "user_organisation_onboarding"
  post "/onboarding/user/:id/organisation", to: "onboarding_users#update_organisation", as: "update_user_organisation_onboarding"
  get "/onboarding/user/:id/complete", to: "onboarding_users#complete", as: "complete_user_onboarding"
  post "/onboarding/user/:id/create", to: "onboarding_users#create_user", as: "create_user_onboarding"

  # DESKTOP APP ROUTES
  get "/desktop/dashboard", to: "desktop/dashboard#index", as: "desktop_dashboard"
  root "sessions#choose_platform", as: "root"

  get "/desktop/grooms", to: "desktop/grooms#index", as: "desktop_grooms"
  get "/desktop/grooms/new", to: "desktop/grooms#new", as: "desktop_grooms_new"
  get "/desktop/grooms/:id", to: "desktop/grooms#show", as: "desktop_groom"
  get "/desktop/grooms/:id/images", to: "desktop/grooms#images", as: "desktop_groom_images"
  post "/desktop/grooms/:id/images/upload", to: "desktop/grooms#upload_image", as: "desktop_groom_images_upload"
  delete "/desktop/grooms/:id/images/:image_id", to: "desktop/grooms#destroy_image", as: "desktop_groom_images_destroy"
  patch "/desktop/grooms/:id/update", to: "desktop/grooms#update", as: "desktop_groom_update"
  
  get "/desktop/temporary_grooms/new", to: "desktop/temporary_grooms#new", as: "desktop_temporary_grooms_new"
  get "/desktop/temporary_grooms/:id", to: "desktop/temporary_grooms#show", as: "desktop_temporary_groom"
  post "/desktop/temporary_grooms/create", to: "desktop/temporary_grooms#create", as: "desktop_temporary_grooms_create"
  get "/desktop/temporary_grooms/:id/images", to: "desktop/temporary_grooms#images", as: "desktop_temporary_groom_images"
  post "/desktop/temporary_grooms/:id/images/upload", to: "desktop/temporary_grooms#upload_image", as: "desktop_temporary_groom_images_upload"
  delete "/desktop/temporary_grooms/:id/images/:image_id", to: "desktop/temporary_grooms#destroy_image", as: "desktop_temporary_groom_images_destroy"
  patch "/desktop/temporary_grooms/:id/update", to: "desktop/temporary_grooms#update", as: "desktop_temporary_groom_update"
  
  get "/desktop/daycare_visits", to: "desktop/daycare_visits#index", as: "desktop_daycare_visits"
  get "/desktop/daycare_visits/new", to: "desktop/daycare_visits#new", as: "desktop_daycare_visits_new"
  get "/desktop/daycare_visits/:id", to: "desktop/daycare_visits#show", as: "desktop_daycare_visit"
  patch "/desktop/daycare_visits/:id/update", to: "desktop/daycare_visits#update", as: "desktop_daycare_visit_update"

  get "/desktop/temporary_daycare_visits/new", to: "desktop/temporary_daycare_visits#new", as: "desktop_temporary_daycare_visits_new"
  get "/desktop/temporary_daycare_visits/:id", to: "desktop/temporary_daycare_visits#show", as: "desktop_temporary_daycare_visit"
  post "/desktop/temporary_daycare_visits/create", to: "desktop/temporary_daycare_visits#create", as: "desktop_temporary_daycare_visit_create"
  patch "/desktop/temporary_daycare_visits/:id/update", to: "desktop/temporary_daycare_visits#update", as: "desktop_temporary_daycare_visit_update"

  # customer routes
  get "/desktop/users", to: "desktop/users/customers#index", as: "desktop_users"
  get "/desktop/users/new", to: "desktop/users/customers#new", as: "desktop_users_new"
  get "/desktop/users/:id", to: "desktop/users/customers#show", as: "desktop_user"
  get "/desktop/users/:id/edit", to: "desktop/users/customers#edit", as: "desktop_user_edit"
  post "/desktop/customers/import", to: "desktop/users/customers#import", as: "desktop_user_import"
  get "/desktop/users/:id/booking_settings/edit", to: "desktop/users/customers#booking_settings", as: "desktop_user_booking_settings_edit"

  # employee routes
  get "/desktop/employees", to: "desktop/users/employees#index", as: "desktop_employees"
  get "/desktop/employees/new", to: "desktop/users/employees#new", as: "desktop_employees_new"
  get "/desktop/employees/:id", to: "desktop/users/employees#show", as: "desktop_employee"
  get "/desktop/employees/:id/edit", to: "desktop/users/employees#edit", as: "desktop_employee_edit"
  
  # generic user action routes
  get "/desktop/sign_up", to: "desktop/users/users#new", as: "desktop_user_new"
  post "/desktop/users/create", to: "desktop/users/users#create", as: "desktop_users_create"
  patch "/desktop/users/:id/update", to: "desktop/users/users#update", as: "desktop_user_update"
  delete "/desktop/users/:id/delete", to: "desktop/users/users#delete", as: "desktop_user_delete"

  get "/desktop/products", to: "desktop/products#index", as: "desktop_products"
  get "/desktop/products/new", to: "desktop/products#new", as: "desktop_products_new"
  post "/desktop/products/create", to: "desktop/products#create", as: "desktop_products_create"
  get "/desktop/products/:id", to: "desktop/products#show", as: "desktop_product"
  get "/desktop/products/:id/edit", to: "desktop/products#edit", as: "desktop_product_edit"
  patch "/desktop/products/:id/update", to: "desktop/products#update", as: "desktop_products_update"
  delete "/desktop/products/:id/delete", to: "desktop/products#delete", as: "desktop_products_delete"

  get "/desktop/products/:id/pictures", to: "desktop/products#pictures", as: "desktop_product_pictures"
  post "/desktop/products/:id/pictures/create", to: "desktop/products#upload_new_image", as: "desktop_product_pictures_upload"
  delete "/desktop/products/:id/images/:image_id", to: "desktop/products#delete_product_picture", as: "desktop_product_pictures_delete"

  get "/desktop/categories", to: "desktop/categories#index", as: "desktop_categories"
  get "/desktop/categories/new", to: "desktop/categories#new", as: "desktop_categories_new"
  post "/desktop/categories/create", to: "desktop/categories#create", as: "desktop_categories_create"
  get "/desktop/categories/:id", to: "desktop/categories#show", as: "desktop_category"
  get "/desktop/categories/:id/edit", to: "desktop/categories#edit", as: "desktop_category_edit"
  patch "/desktop/categories/:id/update", to: "desktop/categories#update", as: "desktop_categories_update"
  delete "/desktop/categories/:id/delete", to: "desktop/categories#delete", as: "desktop_categories_delete"

  get "/desktop/categories/:id/pictures", to: "desktop/categories#pictures", as: "desktop_category_pictures"
  post "/desktop/categories/:id/pictures/create", to: "desktop/categories#upload_new_image", as: "desktop_category_pictures_upload"
  delete "/desktop/categories/:id/images/:image_id", to: "desktop/categories#delete_category_picture", as: "desktop_category_pictures_delete"

  get "/desktop/users/:id/pets/new", to: "desktop/pets#new", as: "desktop_pets_new"
  post "/desktop/pets/create", to: "desktop/pets#create", as: "desktop_pets_create"
  patch "/desktop/pets/:id", to: "desktop/pets#update", as: "desktop_pets_update"
  get "/desktop/pets/:id", to: "desktop/pets#show", as: "desktop_pets"
  get "/desktop/pets/:id/images", to: "desktop/pets#pictures", as: "desktop_pets_pictures"
  post "/desktop/pets/:id/images", to: "desktop/pets#upload_new_image", as: "desktop_pets_pictures_upload"
  delete "/desktop/pets/:id/images/:image_id", to: "desktop/pets#delete_pet_picture", as: "desktop_pets_pictures_delete"
  delete "/desktop/pets/:id", to: "desktop/pets#delete", as: "desktop_pets_delete"

  get "/desktop/reports", to: "desktop/reports#index", as: "desktop_reports"

  get "/desktop/settings", to: "desktop/settings#index", as: "desktop_settings"
  get "/desktop/settings/user", to: "desktop/settings#user", as: "desktop_user_settings"
  patch "/desktop/settings/user", to: "desktop/settings#update_user", as: "update_desktop_user_settings"
  get "/desktop/settings/organisation", to: "desktop/settings#organisation", as: "desktop_organisation_settings"
  patch "/desktop/settings/organisation", to: "desktop/settings#update_organisation", as: "update_desktop_organisation_settings"
  get "/desktop/settings/retail", to: "desktop/settings#retail", as: "desktop_retail_settings"
  patch "/desktop/settings/retail", to: "desktop/settings#update_retail", as: "update_desktop_retail_settings"

  get "/desktop/organisations/new", to: "desktop/organisations#new", as: "desktop_organisations_new"
  post "/desktop/organisations/create", to: "desktop/organisations#create", as: "desktop_organisations_create"

  # Employee App Routes
  get "/employee_app/dashboard", to: "employee_app/mobile_app#profile", as: "mobile_app_profile"

  get "/employee_app/settings", to: "employee_app/mobile_app#user_settings", as: "employee_app_settings"
  patch "/employee_app/settings", to: "employee_app/mobile_app#update_user_settings", as: "employee_app_update_user_settings"

  get "/employee_app/grooms", to: "employee_app/grooms#index", as: "employee_app_grooms"
  get "/employee_app/grooms/:id", to: "employee_app/grooms#show", as: "employee_app_groom"
  patch "/employee_app/grooms/:id/update", to: "employee_app/grooms#update", as: "employee_app_groom_update"
  get "/employee_app/grooms/:id/images", to: "employee_app/grooms#images", as: "employee_app_groom_images"
  post "/employee_app/grooms/:id/images/upload", to: "employee_app/grooms#upload_image", as: "employee_app_groom_images_upload"
  delete "/employee_app/grooms/:id/images/:image_id", to: "employee_app/grooms#destroy_image", as: "employee_app_groom_images_destroy"

  get "/employee_app/temporary_grooms/:id", to: "employee_app/temporary_grooms#show", as: "employee_app_temporary_groom"
  patch "/employee_app/temporary_grooms/:id/update", to: "employee_app/temporary_grooms#update", as: "employee_app_temporary_groom_update"
  get "/employee_app/temporary_grooms/:id/images", to: "employee_app/temporary_grooms#images", as: "employee_app_temporary_groom_images"
  post "/employee_app/temporary_grooms/:id/images/upload", to: "employee_app/temporary_grooms#upload_image", as: "employee_app_temporary_groom_images_upload"
  delete "/employee_app/temporary_grooms/:id/images/:image_id", to: "employee_app/temporary_grooms#destroy_image", as: "employee_app_temporary_groom_images_destroy"

  get "/employee_app/daycare_visits", to: "employee_app/daycare_visits#index", as: "employee_app_daycare_visits"
  get "/employee_app/daycare_visits/:id", to: "employee_app/daycare_visits#show", as: "employee_app_daycare_visit"
  patch "/employee_app/daycare_visits/:id/update", to: "employee_app/daycare_visits#update", as: "employee_app_daycare_visit_update"

  get "/employee_app/temporary_daycare_visits/:id", to: "employee_app/temporary_daycare_visits#show", as: "employee_app_temporary_daycare_visit"
  patch "/employee_app/temporary_daycare_visits/:id/update", to: "employee_app/temporary_daycare_visits#update", as: "employee_app_temporary_daycare_visit_update"
end
