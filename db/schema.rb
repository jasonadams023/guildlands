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

ActiveRecord::Schema.define(version: 20170103230954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.hstore   "effects"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "category"
    t.index ["location_id"], name: "index_activities_on_location_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "guild_abilities", force: :cascade do |t|
    t.string   "name"
    t.integer  "rep_cost"
    t.text     "description"
    t.hstore   "effect"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "guild_abilities_guilds", id: false, force: :cascade do |t|
    t.integer "guild_id",         null: false
    t.integer "guild_ability_id", null: false
  end

  create_table "guild_halls", force: :cascade do |t|
    t.string   "name"
    t.integer  "size"
    t.integer  "unit_limit"
    t.hstore   "effects"
    t.integer  "guild_id"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["guild_id"], name: "index_guild_halls_on_guild_id", using: :btree
    t.index ["location_id"], name: "index_guild_halls_on_location_id", using: :btree
  end

  create_table "guilds", force: :cascade do |t|
    t.string   "name"
    t.integer  "total_rep"
    t.integer  "spent_rep"
    t.integer  "money"
    t.string   "avatar_url"
    t.hstore   "effects"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_guilds_on_user_id", using: :btree
  end

  create_table "hall_inventories", force: :cascade do |t|
    t.integer  "guild_hall_id"
    t.integer  "item_id"
    t.integer  "total"
    t.integer  "available"
    t.integer  "selling"
    t.integer  "using"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["guild_hall_id"], name: "index_hall_inventories_on_guild_hall_id", using: :btree
    t.index ["item_id"], name: "index_hall_inventories_on_item_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.hstore   "effects"
    t.string   "category"
    t.integer  "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "max_value"
    t.integer  "demand"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.hstore   "effects"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "guild_id"
    t.integer  "turn"
    t.text     "message"
    t.hstore   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_id"], name: "index_logs_on_guild_id", using: :btree
  end

  create_table "maps", force: :cascade do |t|
    t.integer  "guild_id"
    t.string   "name"
    t.integer  "dimensions", default: [],              array: true
    t.text     "tile_types", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["guild_id"], name: "index_maps_on_guild_id", using: :btree
  end

  create_table "market_orders", force: :cascade do |t|
    t.integer  "hall_inventory_id"
    t.integer  "item_id"
    t.integer  "amount"
    t.integer  "price"
    t.integer  "category"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["hall_inventory_id"], name: "index_market_orders_on_hall_inventory_id", using: :btree
    t.index ["item_id"], name: "index_market_orders_on_item_id", using: :btree
  end

  create_table "room_inventories", force: :cascade do |t|
    t.integer  "guild_hall_id"
    t.integer  "room_id"
    t.hstore   "modifications"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["guild_hall_id"], name: "index_room_inventories_on_guild_hall_id", using: :btree
    t.index ["room_id"], name: "index_room_inventories_on_room_id", using: :btree
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "size"
    t.integer  "cost"
    t.text     "description"
    t.hstore   "effects"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "unit_abilities", force: :cascade do |t|
    t.string   "name"
    t.integer  "xp_cost"
    t.string   "category"
    t.integer  "ap_cost"
    t.integer  "sp_cost"
    t.text     "description"
    t.hstore   "effects"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "unit_abilities_units", id: false, force: :cascade do |t|
    t.integer "unit_id",         null: false
    t.integer "unit_ability_id", null: false
  end

  create_table "unit_inventories", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "hall_inventory_id"
    t.integer  "amount"
    t.boolean  "equipped"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["hall_inventory_id"], name: "index_unit_inventories_on_hall_inventory_id", using: :btree
    t.index ["unit_id"], name: "index_unit_inventories_on_unit_id", using: :btree
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.integer  "total_xp"
    t.integer  "spent_xp"
    t.integer  "hiring_cost"
    t.integer  "upkeep_cost"
    t.integer  "max_hp"
    t.integer  "current_hp"
    t.integer  "max_sp"
    t.integer  "current_sp"
    t.integer  "strength"
    t.integer  "agility"
    t.integer  "vitality"
    t.integer  "stamina"
    t.integer  "intelligence"
    t.integer  "focus"
    t.integer  "dodge"
    t.integer  "resilience"
    t.integer  "resist"
    t.hstore   "effects"
    t.integer  "guild_hall_id"
    t.integer  "activity_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["activity_id"], name: "index_units_on_activity_id", using: :btree
    t.index ["guild_hall_id"], name: "index_units_on_guild_hall_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "username"
    t.string   "auth",                   default: "player"
    t.boolean  "cheater?",               default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "activities", "locations"
  add_foreign_key "guild_halls", "guilds"
  add_foreign_key "guild_halls", "locations"
  add_foreign_key "guilds", "users"
  add_foreign_key "hall_inventories", "guild_halls"
  add_foreign_key "hall_inventories", "items"
  add_foreign_key "logs", "guilds"
  add_foreign_key "maps", "guilds"
  add_foreign_key "market_orders", "hall_inventories"
  add_foreign_key "market_orders", "items"
  add_foreign_key "room_inventories", "guild_halls"
  add_foreign_key "room_inventories", "rooms"
  add_foreign_key "unit_inventories", "hall_inventories"
  add_foreign_key "unit_inventories", "units"
  add_foreign_key "units", "activities"
  add_foreign_key "units", "guild_halls"
end
