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

ActiveRecord::Schema.define(version: 2019_12_31_024148) do

  create_table "exchanges", force: :cascade do |t|
    t.integer "blocktime", null: false
    t.string "tx_id", null: false
    t.integer "bitcoin_trading_volume", null: false
    t.integer "fiat_trading_volume", null: false
    t.integer "fiat_balance", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_exchanges_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_exchanges_on_user_id"
  end

  create_table "finances", force: :cascade do |t|
    t.integer "branch_number", default: 123, null: false
    t.integer "account_number", default: 1234567, null: false
    t.string "name", default: "", null: false
    t.integer "fiat_jpy", default: 0, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_finances_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_finances_on_user_id"
  end

  create_table "keys", force: :cascade do |t|
    t.integer "wallet_id"
    t.string "public_key", null: false
    t.string "private_key", null: false
    t.boolean "is_hot", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.index ["wallet_id", "created_at"], name: "index_keys_on_wallet_id_and_created_at"
    t.index ["wallet_id"], name: "index_keys_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_wallets_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

end
