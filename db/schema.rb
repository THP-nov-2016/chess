# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161227190020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "move_result"
    t.integer  "black_player_id"
    t.integer  "white_player_id"
    t.integer  "current_turn"
    t.integer  "winning_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blitz",            default: false
    t.integer  "last_moved_piece_id"
    t.boolean  "white_draw"
    t.boolean  "black_draw"
    t.boolean  "white_forfeit"
    t.boolean  "black_forfeit"
    t.boolean  "has_started",         default: false
    t.boolean  "white_ready",         default: false
    t.boolean  "black_ready",         default: false
  end

  create_table "pieces", force: true do |t|
    t.string   "type"
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "x_position"
    t.integer  "y_position"
    t.boolean  "captured",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "captured_at"
    t.integer  "moves",       default: 0
  end

  create_table "players", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.integer  "wins",                   default: 0
    t.integer  "draws",                  default: 0
    t.integer  "losses",                 default: 0
  end

  add_index "players", ["email"], name: "index_players_on_email", unique: true, using: :btree
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true, using: :btree

  create_table "timers", force: true do |t|
    t.time     "time"
    t.integer  "player_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_left"
    t.datetime "start_time"
    t.boolean  "running"
  end

end
