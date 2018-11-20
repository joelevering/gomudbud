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

ActiveRecord::Schema.define(version: 2018_11_20_212005) do

  create_table "behavior_actions", force: :cascade do |t|
    t.string "action"
    t.string "payload"
    t.integer "behavior_id"
  end

  create_table "behaviors", force: :cascade do |t|
    t.string "trigger"
    t.float "chance"
    t.integer "npc_id"
  end

  create_table "combat_behaviors", force: :cascade do |t|
    t.string "skill_name"
    t.float "chance"
    t.integer "npc_id"
  end

  create_table "exits", force: :cascade do |t|
    t.integer "room_id"
    t.integer "linked_room_id"
    t.string "key"
    t.string "description"
  end

  create_table "npcs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "class_name"
    t.integer "level"
    t.integer "exp"
    t.integer "room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
  end

end
