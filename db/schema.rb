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

ActiveRecord::Schema.define(version: 20160215195338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", id: false, force: :cascade do |t|
    t.integer  "songkick_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "spotify_id"
    t.text     "top_spotify_tracks"
    t.jsonb    "genres",             default: [], null: false
    t.string   "musicbrainz_id",                  null: false
    t.jsonb    "similar_artists",    default: [], null: false
    t.index ["musicbrainz_id"], name: "index_artists_on_musicbrainz_id", unique: true, using: :btree
    t.index ["similar_artists"], name: "similar_artists_json", using: :gin
  end

  create_table "location_search_results", force: :cascade do |t|
    t.string   "query"
    t.text     "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metro_area_search_results", primary_key: "metro_area_id", id: :integer, force: :cascade do |t|
    t.text     "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", primary_key: "session_id", id: :string, force: :cascade do |t|
    t.text    "stars"
    t.integer "metro_area_id"
  end

end
