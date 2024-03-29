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

ActiveRecord::Schema.define(version: 20141206025131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

  create_table "activities", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "action",       null: false
    t.datetime "deleted_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["subject_id", "subject_type"], name: "index_activities_on_subject_id_and_subject_type", using: :btree

  create_table "addresses", force: true do |t|
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.integer  "parent_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parent_type"
    t.text     "easypost_id"
  end

  create_table "boutiques", force: true do |t|
    t.string   "name"
    t.string   "short_code",   null: false
    t.integer  "items_count"
    t.datetime "deleted_at"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "pinterest"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stream_photo"
    t.text     "cover_photo"
    t.text     "email"
    t.text     "phone"
    t.text     "recipient_id"
  end

  add_index "boutiques", ["short_code"], name: "index_boutiques_on_short_code", unique: true, using: :btree

  create_table "brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "cart_items", force: true do |t|
    t.integer  "cart_id",                                                        null: false
    t.integer  "item_id",                                                        null: false
    t.integer  "item_version",                                                   null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.string   "size"
    t.integer  "supporting_boutique_id"
    t.integer  "supplying_boutique_id"
    t.decimal  "shipping",               precision: 5, scale: 2, default: 0.0
    t.decimal  "tax",                    precision: 9, scale: 2, default: 0.0
    t.text     "shipment_id"
    t.text     "shipping_rate_id"
    t.integer  "billing_address_id"
    t.json     "shipping_label"
    t.datetime "completed_at"
    t.text     "cancellation_refund_id"
    t.json     "return_label"
    t.integer  "refund_ledger_entry_id"
    t.boolean  "refund_requested",                               default: false
    t.boolean  "refundable",                                     default: true
    t.text     "parcel_id"
    t.text     "tracking_code"
    t.datetime "shipped_at"
    t.datetime "delivered_at"
  end

  add_index "cart_items", ["supplying_boutique_id"], name: "index_cart_items_on_supplying_boutique_id", using: :btree
  add_index "cart_items", ["supporting_boutique_id"], name: "index_cart_items_on_supporting_boutique_id", using: :btree

  create_table "carts", force: true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "transaction_id"
    t.integer  "shipping_address_id"
    t.datetime "captured_at"
    t.datetime "refunded_at"
    t.integer  "ledger_entry_id"
  end

  create_table "categories", force: true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "items_count"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "commissions", force: true do |t|
    t.integer  "cart_item_id"
    t.integer  "boutique_id"
    t.text     "recipient_id"
    t.text     "transfer_id"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "customer_orders", force: true do |t|
    t.string   "name"
    t.integer  "boutique_id"
    t.string   "order_number"
    t.string   "customer_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shipping_label"
    t.integer  "fulfillment_status"
    t.string   "item"
    t.integer  "fun"
    t.integer  "item_id"
    t.string   "item_size"
  end

  create_table "item_options", force: true do |t|
    t.integer  "item_id"
    t.string   "name"
    t.string   "value"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "item_photos", force: true do |t|
    t.integer  "item_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.decimal  "price"
    t.text     "description"
    t.text     "fit"
    t.text     "construction"
    t.integer  "boutique_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.decimal  "model_height",          precision: 5, scale: 2
    t.decimal  "model_chest",           precision: 5, scale: 2
    t.decimal  "model_waist",           precision: 5, scale: 2
    t.decimal  "model_hips",            precision: 5, scale: 2
    t.text     "model_size"
    t.json     "sizes"
    t.boolean  "approved",                                      default: false, null: false
    t.integer  "primary_category_id"
    t.integer  "secondary_category_id"
    t.decimal  "weight",                precision: 5, scale: 2, default: 1.0
    t.decimal  "packaging_width",       precision: 9, scale: 2, default: 12.0
    t.decimal  "packaging_height",      precision: 9, scale: 2, default: 12.0
    t.decimal  "packaging_length",      precision: 9, scale: 2, default: 12.0
    t.text     "parcel_id"
    t.integer  "declined_boutique_ids",                                                      array: true
    t.decimal  "discount_amount"
    t.integer  "list_on_trunksale"
    t.string   "style"
  end

  create_table "ledger_entries", force: true do |t|
    t.integer  "user_id"
    t.decimal  "value",          precision: 9, scale: 2
    t.text     "description"
    t.integer  "whodunnit_id"
    t.string   "whodunnit_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "ledger_entries", ["whodunnit_id", "whodunnit_type"], name: "index_ledger_entries_on_whodunnit_id_and_whodunnit_type", using: :btree

  create_table "restock_notifications", id: false, force: true do |t|
    t.integer "item_id"
    t.integer "user_id"
  end

  create_table "shipping_events", force: true do |t|
    t.string   "event_id"
    t.string   "object"
    t.string   "mode"
    t.string   "description"
    t.json     "previous_attributes"
    t.json     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_invite_tokens", force: true do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.text     "code"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                                default: "",  null: false
    t.string   "encrypted_password",                                   default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                        default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                                      default: 0,   null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "raw_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parent_type"
    t.string   "photo"
    t.integer  "roles_mask"
    t.datetime "deleted_at"
    t.string   "time_zone"
    t.decimal  "account_balance",              precision: 9, scale: 2, default: 0.0
    t.datetime "last_viewed_notifications_at"
    t.text     "api_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
