# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150830085327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "time_zone"
  end

  add_index "admin_users", ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true, using: :btree
  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true, using: :btree

  create_table "campaign_offers", force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "offer_id",    null: false
  end

  add_index "campaign_offers", ["campaign_id", "offer_id"], name: "index_campaign_offers_on_campaign_id_and_offer_id", unique: true, using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",        null: false
    t.date     "start"
    t.date     "finish"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "configurations", force: :cascade do |t|
    t.string   "key",                     null: false
    t.text     "value"
    t.string   "form_type",               null: false
    t.string   "form_collection_command"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "configurations", ["key"], name: "index_configurations_on_key", unique: true, using: :btree

  create_table "customer_discounts", force: :cascade do |t|
    t.integer  "customer_id", null: false
    t.integer  "discount_id", null: false
    t.string   "reference"
    t.date     "expiry"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "customer_discounts", ["customer_id", "discount_id"], name: "index_customer_discounts_on_customer_id_and_discount_id", unique: true, using: :btree

  create_table "customer_subscriptions", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "subscription_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "customer_subscriptions", ["customer_id", "subscription_id"], name: "index_customer_subscriptions_on_customer_id_and_subscription_id", unique: true, using: :btree
  add_index "customer_subscriptions", ["subscription_id", "customer_id"], name: "index_customer_subscriptions_on_subscription_id_and_customer_id", unique: true, using: :btree

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       null: false
    t.string   "email"
    t.string   "phone"
    t.text     "address"
    t.string   "country"
    t.string   "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["email", "name"], name: "index_customers_on_email_and_name", using: :btree

  create_table "discount_prices", force: :cascade do |t|
    t.integer "discount_id", null: false
    t.integer "price_id",    null: false
  end

  add_index "discount_prices", ["discount_id", "price_id"], name: "index_discount_prices_on_discount_id_and_price_id", unique: true, using: :btree
  add_index "discount_prices", ["price_id", "discount_id"], name: "index_discount_prices_on_price_id_and_discount_id", unique: true, using: :btree

  create_table "discounts", force: :cascade do |t|
    t.string   "name",        null: false
    t.boolean  "requestable"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "discounts", ["name"], name: "index_discounts_on_name", unique: true, using: :btree

  create_table "offer_prices", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "price_id", null: false
  end

  add_index "offer_prices", ["offer_id", "price_id"], name: "index_offer_prices_on_offer_id_and_price_id", unique: true, using: :btree

  create_table "offer_products", force: :cascade do |t|
    t.integer  "offer_id",                   null: false
    t.integer  "product_id",                 null: false
    t.boolean  "optional",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "offer_products", ["offer_id", "product_id"], name: "index_offer_products_on_offer_id_and_product_id", unique: true, using: :btree

  create_table "offer_publications", force: :cascade do |t|
    t.integer  "offer_id",                   null: false
    t.integer  "publication_id",             null: false
    t.integer  "quantity",                   null: false
    t.string   "unit",                       null: false
    t.integer  "subscribers",    default: 1, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "offer_publications", ["offer_id", "publication_id"], name: "index_offer_publications_on_offer_id_and_publication_id", unique: true, using: :btree

  create_table "offers", force: :cascade do |t|
    t.string   "name",         null: false
    t.date     "start"
    t.date     "finish"
    t.integer  "trial_period"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "purchase_id"
    t.integer  "subscription_id"
    t.string   "price_name",      null: false
    t.string   "discount_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "payments", ["subscription_id", "purchase_id"], name: "index_payments_on_subscription_id_and_purchase_id", unique: true, using: :btree

  create_table "prices", force: :cascade do |t|
    t.string   "currency",             null: false
    t.string   "name",                 null: false
    t.integer  "amount_cents",         null: false
    t.integer  "monthly_payments"
    t.integer  "initial_amount_cents"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "prices", ["currency", "name"], name: "index_prices_on_currency_and_name", unique: true, using: :btree

  create_table "product_orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "purchase_id"
    t.integer  "product_id"
    t.date     "shipped"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "product_orders", ["customer_id", "purchase_id", "product_id"], name: "index_product_orders_on_customer_purchase_and_product_ids", unique: true, using: :btree
  add_index "product_orders", ["product_id"], name: "index_product_orders_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",                           null: false
    t.integer  "stock"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "shipped_count",      default: 0, null: false
    t.integer  "unshipped_count",    default: 0, null: false
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree

  create_table "publications", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "website",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "subscriptions_count", default: 0, null: false
  end

  add_index "publications", ["name"], name: "index_publications_on_name", unique: true, using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "offer_id",             null: false
    t.string   "currency",             null: false
    t.integer  "amount_cents",         null: false
    t.string   "token"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "cancelled_at"
    t.integer  "monthly_payments"
    t.integer  "initial_amount_cents"
    t.date     "payment_due"
  end

  add_index "purchases", ["offer_id"], name: "index_purchases_on_offer_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "publication_id",      null: false
    t.integer  "user_id"
    t.integer  "subscribers",         null: false
    t.date     "subscribed",          null: false
    t.date     "expiry"
    t.text     "cancellation_reason"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "subscriptions", ["publication_id"], name: "index_subscriptions_on_publication_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer "purchase_id",  null: false
    t.integer "amount_cents"
    t.string  "message",      null: false
  end

  add_index "transactions", ["message"], name: "index_transactions_on_message", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "currency"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "time_zone"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "campaign_offers", "campaigns"
  add_foreign_key "campaign_offers", "offers"
  add_foreign_key "customer_discounts", "customers"
  add_foreign_key "customer_discounts", "discounts"
  add_foreign_key "customer_subscriptions", "customers"
  add_foreign_key "customer_subscriptions", "subscriptions"
  add_foreign_key "customers", "users"
  add_foreign_key "discount_prices", "discounts"
  add_foreign_key "discount_prices", "prices"
  add_foreign_key "offer_prices", "offers"
  add_foreign_key "offer_prices", "prices"
  add_foreign_key "offer_products", "offers"
  add_foreign_key "offer_products", "products"
  add_foreign_key "offer_publications", "offers"
  add_foreign_key "offer_publications", "publications"
  add_foreign_key "payments", "purchases"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "product_orders", "customers"
  add_foreign_key "product_orders", "products"
  add_foreign_key "product_orders", "purchases"
  add_foreign_key "purchases", "offers"
  add_foreign_key "subscriptions", "publications"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "transactions", "purchases"
end
