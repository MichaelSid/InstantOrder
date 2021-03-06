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

ActiveRecord::Schema.define(version: 20161108211618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "mobile_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_id"
    t.string   "company"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "full_name"
    t.boolean  "admin?",                 default: false
    t.text     "address"
    t.string   "postcode"
    t.text     "address_l1"
    t.text     "address_l2"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "charges", force: true do |t|
    t.float    "amount"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_type"
    t.decimal  "duration"
    t.decimal  "hourly_fee"
    t.integer  "account_id"
    t.decimal  "materials_total_cost"
    t.decimal  "discount"
    t.decimal  "quote_fee"
    t.decimal  "minimum_charge"
    t.integer  "number_contractors"
  end

  add_index "charges", ["account_id"], name: "index_charges_on_account_id", using: :btree
  add_index "charges", ["order_id"], name: "index_charges_on_order_id", using: :btree

  create_table "contractors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "service_type"
    t.integer  "nunmber_jobs_done"
    t.float    "gross_paid"
    t.float    "materials_refund"
    t.float    "net_pay"
    t.datetime "last_job_at"
    t.float    "rating"
    t.string   "company_name"
    t.text     "description"
    t.datetime "first_job_at"
    t.boolean  "signed_contract",   default: false, null: false
    t.string   "mobile_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_sms_at"
    t.string   "email"
  end

  create_table "messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company"
    t.text     "content"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.text     "details"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["account_id"], name: "index_orders_on_account_id", using: :btree

end
