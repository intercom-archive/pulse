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

ActiveRecord::Schema.define(version: 20141013180417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "metrics", force: true do |t|
    t.string   "title"
    t.string   "datapoint_source"
    t.text     "datapoint_name"
    t.text     "summary"
    t.string   "mitigation_steps"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id"
    t.string   "cloudwatch_namespace"
    t.string   "cloudwatch_identifier"
    t.float    "alarm_warning"
    t.float    "alarm_error"
    t.boolean  "negative_alarming",     default: false, null: false
  end

  add_index "metrics", ["service_id"], name: "index_metrics_on_service_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
