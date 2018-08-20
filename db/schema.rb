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

ActiveRecord::Schema.define(version: 20180820045043) do

  create_table "configs", force: :cascade do |t|
    t.string "name"
    t.string "log_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "environments", force: :cascade do |t|
    t.string "name"
    t.integer "scenario_id"
    t.integer "config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["config_id"], name: "index_environments_on_config_id"
    t.index ["scenario_id"], name: "index_environments_on_scenario_id"
  end

  create_table "extras", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.integer "scenario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scenario_id"], name: "index_extras_on_scenario_id"
  end

  create_table "peers", force: :cascade do |t|
    t.string "name"
    t.string "own_ip"
    t.integer "own_port"
    t.string "dst_ip"
    t.integer "dst_port"
    t.string "protocol"
    t.integer "config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["config_id"], name: "index_peers_on_config_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
