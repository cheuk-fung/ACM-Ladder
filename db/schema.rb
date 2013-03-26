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

ActiveRecord::Schema.define(:version => 20130326091357) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.integer  "exp"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "submissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_id"
    t.integer  "original_id"
    t.text     "code"
    t.integer  "language",    :limit => 1
    t.integer  "time"
    t.integer  "memory"
    t.integer  "status",      :limit => 1, :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.text     "error"
  end

  add_index "submissions", ["problem_id"], :name => "index_submissions_on_problem_id"
  add_index "submissions", ["user_id"], :name => "index_submissions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "handle",                                              :null => false
    t.integer  "level",                  :limit => 1, :default => 0
    t.string   "school"
    t.integer  "student_id"
    t.string   "college"
    t.string   "major"
    t.string   "mobile"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",                  :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["handle"], :name => "index_users_on_handle", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
