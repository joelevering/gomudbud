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

ActiveRecord::Schema[8.1].define(version: 2026_08_17_215541) do
  create_table "behavior_actions", force: :cascade do |t|
    t.string "action"
    t.integer "behavior_id"
    t.datetime "created_at", null: false
    t.string "payload"
    t.datetime "updated_at", null: false
  end

  create_table "behaviors", force: :cascade do |t|
    t.float "chance"
    t.datetime "created_at", null: false
    t.integer "npc_id"
    t.string "trigger"
    t.datetime "updated_at", null: false
  end

  create_table "combat_behaviors", force: :cascade do |t|
    t.float "chance"
    t.datetime "created_at", null: false
    t.integer "npc_id"
    t.string "skill_name"
    t.datetime "updated_at", null: false
  end

  create_table "exits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "key"
    t.integer "linked_room_id"
    t.integer "room_id"
    t.datetime "updated_at", null: false
  end

  create_table "npcs", force: :cascade do |t|
    t.string "class_name"
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "exp"
    t.integer "level"
    t.string "name"
    t.integer "room_id"
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end
end
