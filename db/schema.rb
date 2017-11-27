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

ActiveRecord::Schema.define(version: 20171107083058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dishes", force: :cascade do |t|
    t.integer "restaurant_id"
    t.string "name"
    t.string "description"
    t.string "photo"
    t.string "price"
    t.string "type_dish"
    t.integer "number_of_ratings", default: 0
    t.float "average_ratings", default: 0.0
    t.float "sum_ratings", default: 0.0
    t.float "actual_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "dishes_evaluations", id: false, force: :cascade do |t|
    t.bigint "evaluation_id"
    t.bigint "dish_id"
    t.index ["dish_id"], name: "index_dishes_evaluations_on_dish_id"
    t.index ["evaluation_id"], name: "index_dishes_evaluations_on_evaluation_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "dish_id"
    t.integer "restaurant_id"
    t.float "evaluation"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "dish_id"], name: "index_evaluations_on_user_id_and_dish_id", unique: true
  end

  create_table "evaluations_users", id: false, force: :cascade do |t|
    t.bigint "evaluation_id"
    t.bigint "user_id"
    t.index ["evaluation_id"], name: "index_evaluations_users_on_evaluation_id"
    t.index ["user_id"], name: "index_evaluations_users_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "subject"
    t.string "text"
    t.integer "evaluation_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "photos", array: true
    t.integer "number_of_ratings", default: 0
    t.float "average_ratings", default: 0.0
    t.float "sum_ratings", default: 0.0
    t.float "actual_rating"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "g_id"
    t.integer "place_Country"
    t.integer "place_City"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "nickname"
    t.string "name"
    t.string "image"
    t.string "first_name"
    t.string "last_name"
    t.string "number_phone"
    t.string "avatar"
    t.string "email"
    t.integer "number_of_evaluations", default: 0
    t.float "average_ratings_evaluations", default: 0.0
    t.float "sum_ratings_of_evaluations", default: 0.0
    t.float "latitude"
    t.float "longitude"
    t.boolean "admin", default: false
    t.string "ban_time", default: "2017-11-26 11:24:09.815374"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
