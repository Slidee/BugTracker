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

ActiveRecord::Schema.define(:version => 20110319174252) do

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "logo"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["slug"], :name => "index_projects_on_slug", :unique => true

  create_table "sprints", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "goals"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "sprints", ["project_id"], :name => "index_sprints_on_project_id"

  create_table "task_priorities", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_priorities", ["position"], :name => "index_task_priorities_on_position", :unique => true

  create_table "task_statuses", :force => true do |t|
    t.string   "name"
    t.string   "type_enum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_statuses", ["type_enum"], :name => "index_task_statuses_on_type_enum"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
