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

ActiveRecord::Schema.define(version: 20150609162928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email",      null: false
    t.string   "password",   null: false
    t.string   "name",       null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "albums", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
    t.string   "uri",        null: false
    t.string   "list",       null: false
    t.string   "spotify_id"
  end

  create_table "artists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
    t.string   "uri",        null: false
    t.string   "list",       null: false
    t.string   "spotify_id"
  end

  add_index "artists", ["spotify_id", "list"], name: "index_artist", unique: true, using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "list",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "genres", ["name", "list"], name: "index_genres", unique: true, using: :btree

  create_table "playlists", force: :cascade do |t|
    t.string   "ip",         null: false
    t.string   "name",       null: false
    t.string   "uri",        null: false
    t.string   "img_src",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "superusers", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "password",   null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "superusers", ["email"], name: "index_superusers_on_email", unique: true, using: :btree

  create_table "tracks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
    t.string   "uri",        null: false
    t.string   "list",       null: false
    t.string   "spotify_id"
  end

end
