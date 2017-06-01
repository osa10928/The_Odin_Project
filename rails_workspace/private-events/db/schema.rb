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

ActiveRecord::Schema.define(version: 20170316090754) do

  create_table "event_attendings", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "attendee_id"
    t.integer  "attended_event_id"
    t.index ["attended_event_id"], name: "index_event_attendings_on_attended_event_id"
    t.index ["attendee_id"], name: "index_event_attendings_on_attendee_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "place"
    t.date     "day"
    t.text     "desc"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "creator_id"
    t.integer  "attendees_id"
    t.index ["attendees_id"], name: "index_events_on_attendees_id"
    t.index ["creator_id"], name: "index_events_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "events_id"
    t.integer  "attended_events_id"
    t.index ["attended_events_id"], name: "index_users_on_attended_events_id"
    t.index ["events_id"], name: "index_users_on_events_id"
  end

end
