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

ActiveRecord::Schema.define(version: 20150821235221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meme_types", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memes", force: :cascade do |t|
    t.string   "reddit_id"
    t.string   "link_id"
    t.text     "body"
    t.integer  "meme_type_id"
    t.string   "meme_caption",     limit: 1024
    t.string   "link_title",       limit: 1024
    t.string   "subreddit"
    t.string   "subreddit_id"
    t.float    "created_utc"
    t.string   "source"
    t.string   "thumbnail"
    t.integer  "score"
    t.integer  "ups"
    t.float    "link_created_utc"
    t.string   "title",            limit: 1024
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "memetype_associations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "meme_type_id"
    t.integer  "meme_id"
    t.integer  "correct_meme_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "user_auths", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "oauth_provider"
    t.string   "oauth_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
