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

ActiveRecord::Schema.define(:version => 20130123123849) do

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

end
