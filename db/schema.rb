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

ActiveRecord::Schema.define(version: 20171210165743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contexts", force: :cascade do |t|
    t.integer  "context_id"
    t.text     "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_id"], name: "index_contexts_on_context_id", using: :btree
    t.index ["user_id"], name: "index_contexts_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.text     "name"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "kind"
    t.boolean  "on_hold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_projects_on_project_id", using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.text     "name"
    t.integer  "kind"
    t.text     "description"
    t.date     "deferred_date"
    t.text     "delegate"
    t.text     "delegate_note"
    t.boolean  "complete"
    t.integer  "project_id"
    t.integer  "context_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["context_id"], name: "index_tasks_on_context_id", using: :btree
    t.index ["project_id"], name: "index_tasks_on_project_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
    t.text     "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "contexts", "contexts"
  add_foreign_key "contexts", "users"
  add_foreign_key "projects", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "tasks", "contexts"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users"
end
