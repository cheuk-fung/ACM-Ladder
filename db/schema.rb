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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130125094030) do

  create_table "problems", :force => true do |t|
    t.string   "source"
    t.integer  "original_id"
    t.integer  "level"
    t.string   "title"
    t.integer  "time_limit"
    t.integer  "memory_limit"
    t.text     "description"
    t.text     "input"
    t.text     "output"
    t.text     "sample_input"
    t.text     "sample_output"
    t.text     "hint"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "submissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_id"
    t.integer  "original_id"
    t.text     "code"
    t.string   "language"
    t.integer  "time"
    t.integer  "memory"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "submissions", ["problem_id"], :name => "index_submissions_on_problem_id"
  add_index "submissions", ["user_id"], :name => "index_submissions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "handle"
    t.integer  "level"
    t.string   "school"
    t.integer  "student_id"
    t.string   "college"
    t.string   "major"
    t.string   "mobile"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
