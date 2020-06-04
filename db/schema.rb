# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200524171844) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocked_dates", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "navbar", default: false
    t.string "slug"
    t.integer "navbar_order"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.integer "discount_percentage"
    t.datetime "valid_until"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_coupons_on_order_id"
  end

  create_table "delivery_costs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.float "max_distance"
    t.float "min_distance"
    t.boolean "weekend", default: false
    t.datetime "exception"
    t.boolean "published", default: true
    t.boolean "mother", default: false
    t.float "multiplier", default: 1.5
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.bigint "order_id"
    t.bigint "user_id"
    t.bigint "special_order_id"
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
    t.index ["special_order_id"], name: "index_order_details_on_special_order_id"
    t.index ["user_id"], name: "index_order_details_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "address"
    t.date "delivery_date"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.bigint "user_id"
    t.string "order_sku"
    t.jsonb "payment", default: {}
    t.string "state"
    t.string "zipcode"
    t.string "street"
    t.string "neighborhood"
    t.string "city"
    t.string "uf"
    t.string "street_number"
    t.string "complement"
    t.string "country"
    t.bigint "delivery_cost_id"
    t.string "transaction_id"
    t.string "recipient_name"
    t.string "recipient_phone"
    t.jsonb "payment_hash"
    t.float "lat"
    t.float "lng"
    t.float "delivery_distance"
    t.float "latitude"
    t.float "longitude"
    t.jsonb "payment_events", default: {}
    t.string "guest_email"
    t.string "sender_name"
    t.string "sender_phone"
    t.string "request"
    t.boolean "admin_order", default: false
    t.integer "global_id"
    t.string "extra_products"
    t.string "checkout_session_id"
    t.integer "delivery_price_cents", default: 0, null: false
    t.index ["delivery_cost_id"], name: "index_orders_on_delivery_cost_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_attachments", force: :cascade do |t|
    t.integer "product_id"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "short_description"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "photo"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.string "slug"
    t.boolean "same_day_delivery", default: true
    t.integer "fake_price_cents", default: 0, null: false
    t.boolean "featured", default: false
    t.boolean "published", default: true
  end

  create_table "products_sub_categories", id: false, force: :cascade do |t|
    t.bigint "sub_category_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_products_sub_categories_on_product_id"
    t.index ["sub_category_id"], name: "index_products_sub_categories_on_sub_category_id"
  end

  create_table "searches", force: :cascade do |t|
    t.integer "min_price_cents"
    t.string "min_price_currency", default: "BRL", null: false
    t.integer "max_price_cents"
    t.string "max_price_currency", default: "BRL", null: false
    t.string "keywords"
    t.integer "category_id"
  end

  create_table "special_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.string "param_name"
    t.string "slug"
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "birthday"
    t.string "first_name"
    t.string "last_name"
    t.string "cpf"
    t.string "address"
    t.string "phone"
    t.boolean "admin", default: false
    t.boolean "guest", default: false
    t.string "guest_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "coupons", "orders"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "products"
  add_foreign_key "order_details", "special_orders"
  add_foreign_key "order_details", "users"
  add_foreign_key "orders", "delivery_costs"
  add_foreign_key "orders", "users"
  add_foreign_key "sub_categories", "categories"
end
