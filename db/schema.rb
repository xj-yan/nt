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

ActiveRecord::Schema.define(version: 2020_03_11_152939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tweet_id"
    t.string "comment"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "fan_id"
    t.integer "idol_id"
  end

  create_table "has_tags", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "tag_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tweet_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "tweet"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "bio"
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
