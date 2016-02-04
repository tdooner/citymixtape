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

ActiveRecord::Schema.define(version: 20160204061028) do

  create_table "artists", id: false, force: :cascade do |t|
    t.string   "musicbrainz_id",     null: false
    t.string   "spotify_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "top_spotify_tracks"
    t.index ["musicbrainz_id"], name: "index_artists_on_musicbrainz_id", unique: true
  end

  create_table "location_search_results", id: false, force: :cascade do |t|
    t.integer  "id",         null: false
    t.string   "query"
    t.text     "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metro_area_search_results", id: false, force: :cascade do |t|
    t.integer  "metro_area_id", null: false
    t.text     "results"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
