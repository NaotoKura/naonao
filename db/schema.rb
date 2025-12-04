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

ActiveRecord::Schema[7.0].define(version: 2025_11_18_022546) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "title"
    t.integer "priority"
    t.date "due_date"
    t.integer "position"
    t.bigint "lane_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lane_id"], name: "index_cards_on_lane_id"
  end

  create_table "holiday_calendars", force: :cascade do |t|
    t.date "holiday_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lanes", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.bigint "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_lanes_on_board_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memos", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_memos_on_schedule_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "discarded_at"
    t.text "work_content"
    t.text "study_content"
    t.text "notices_content"
    t.index ["discarded_at"], name: "index_posts_on_discarded_at"
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "category", null: false
    t.string "content", null: false
    t.datetime "deadline"
    t.integer "memo_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status"
    t.integer "priority"
    t.date "start_date"
    t.date "due_date"
    t.bigint "user_id"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_tasks_on_creator_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_details", force: :cascade do |t|
    t.integer "user_id"
    t.string "url"
    t.text "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_name"
    t.datetime "discarded_at"
    t.string "code"
    t.integer "age"
    t.integer "year"
    t.integer "month"
    t.integer "gender"
    t.integer "prefecture_id"
  end

  add_foreign_key "boards", "users"
  add_foreign_key "cards", "lanes"
  add_foreign_key "lanes", "boards"
  add_foreign_key "memos", "schedules"
  add_foreign_key "schedules", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "tasks", "users", column: "creator_id"
end
