# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_08_28_121210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_categories_on_organisation_id"
  end

  create_table "daycare_visits", force: :cascade do |t|
    t.date "date", null: false
    t.time "time", null: false
    t.integer "duration", null: false
    t.text "notes"
    t.bigint "pet_id", null: false
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "employee_id"
    t.index ["employee_id"], name: "index_daycare_visits_on_employee_id"
    t.index ["organisation_id"], name: "index_daycare_visits_on_organisation_id"
    t.index ["pet_id"], name: "index_daycare_visits_on_pet_id"
  end

  create_table "grooms", force: :cascade do |t|
    t.date "date", null: false
    t.time "time", null: false
    t.date "last_groom"
    t.text "notes"
    t.bigint "pet_id", null: false
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "employee_id"
    t.index ["employee_id"], name: "index_grooms_on_employee_id"
    t.index ["organisation_id"], name: "index_grooms_on_organisation_id"
    t.index ["pet_id"], name: "index_grooms_on_pet_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.bigint "pet_id"
    t.bigint "onboarding_pet_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_images_on_category_id"
    t.index ["onboarding_pet_id"], name: "index_images_on_onboarding_pet_id"
    t.index ["pet_id"], name: "index_images_on_pet_id"
    t.index ["product_id"], name: "index_images_on_product_id"
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "onboarding_pets", force: :cascade do |t|
    t.string "name", limit: 100
    t.date "dob"
    t.string "breed"
    t.integer "species"
    t.integer "gender"
    t.integer "weight"
    t.string "health_conditions"
    t.bigint "user_id", null: false
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_onboarding_pets_on_organisation_id"
    t.index ["user_id"], name: "index_onboarding_pets_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organisation_id", null: false
    t.integer "status", default: 0
    t.string "payment_intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_orders_on_organisation_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone"
    t.text "address"
    t.text "city"
    t.text "postcode"
    t.integer "maximum_weekly_grooms", default: 0
    t.integer "maximum_daily_grooms", default: 0
    t.integer "maximum_weekly_daycare_visits", default: 0
    t.integer "maximum_daily_daycare_visits", default: 0
    t.integer "revenue_target", default: 0
  end

  create_table "pets", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.date "dob", null: false
    t.string "breed", null: false
    t.integer "visits_remaining", default: 0
    t.integer "grooms_remaining", default: 0
    t.integer "species", default: 0, null: false
    t.integer "gender", default: 0, null: false
    t.integer "weight", default: 0, null: false
    t.string "health_conditions", null: false
    t.bigint "user_id", null: false
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_pets_on_organisation_id"
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "product_category_joins", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_category_joins_on_category_id"
    t.index ["product_id"], name: "index_product_category_joins_on_product_id"
  end

  create_table "product_order_joins", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.index ["order_id"], name: "index_product_order_joins_on_order_id"
    t.index ["product_id"], name: "index_product_order_joins_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.text "description"
    t.decimal "price"
    t.integer "stock"
    t.string "features", default: [], array: true
    t.string "item_number"
    t.string "dimensions"
    t.string "weight"
    t.string "life_stage"
    t.string "breed_size"
    t.string "material"
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_products_on_organisation_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 100, null: false
    t.string "last_name", limit: 100, null: false
    t.string "email", limit: 100, null: false
    t.string "password_digest", null: false
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.text "phone"
    t.integer "weight"
    t.text "address"
    t.text "city"
    t.text "postcode"
    t.integer "role", default: 0
    t.integer "max_grooms", default: 0
    t.integer "max_daycare_visits", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "organisations"
  add_foreign_key "daycare_visits", "organisations"
  add_foreign_key "daycare_visits", "pets"
  add_foreign_key "daycare_visits", "users", column: "employee_id"
  add_foreign_key "grooms", "organisations"
  add_foreign_key "grooms", "pets"
  add_foreign_key "grooms", "users", column: "employee_id"
  add_foreign_key "images", "categories"
  add_foreign_key "images", "onboarding_pets"
  add_foreign_key "images", "pets"
  add_foreign_key "images", "products"
  add_foreign_key "images", "users"
  add_foreign_key "onboarding_pets", "organisations"
  add_foreign_key "onboarding_pets", "users"
  add_foreign_key "orders", "organisations"
  add_foreign_key "orders", "users"
  add_foreign_key "pets", "organisations"
  add_foreign_key "pets", "users"
  add_foreign_key "product_category_joins", "categories"
  add_foreign_key "product_category_joins", "products"
  add_foreign_key "products", "organisations"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "users", "organisations"
end
