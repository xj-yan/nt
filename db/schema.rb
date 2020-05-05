# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_05_200238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "tweet"
    t.integer "user_id"
    t.string "tag_str", default: ""
    t.string "mention_str", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.text "bio"
    t.string "password_digest"
    t.integer "follower_number", default: 0
    t.integer "followee_number", default: 0
    t.integer "tweet_number", default: 0
  end

end
