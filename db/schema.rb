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

ActiveRecord::Schema.define(version: 2021_01_11_154850) do

  create_table "users", id: { type: :integer, limit: 2 }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "email", limit: 255, null: false, collation: "utf8_general_ci"
    t.string "encrypted_password", limit: 255, null: false, collation: "utf8_general_ci"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos_users", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.bigint "youtube_video_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_videos_users_on_user_id"
    t.index ["youtube_video_id"], name: "index_videos_users_on_youtube_video_id"
  end

  create_table "youtube_videos", charset: "utf8mb4", force: :cascade do |t|
    t.string "channel"
    t.string "video_id"
    t.string "title"
    t.binary "thumbnail"
    t.date "release_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
