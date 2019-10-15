# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_14_033113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorization_profiles", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "description"
    t.string "access_type"
    t.string "authz_profile_type"
    t.string "dacl_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "downloadable_acls", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "description"
    t.text "dacl"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "endpoint_groups", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "endpoints", force: :cascade do |t|
    t.string "name"
    t.uuid "uuid"
    t.text "description"
    t.string "mac"
    t.bigint "endpoint_group_id"
    t.bigint "added_by_id"
    t.bigint "modified_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["added_by_id"], name: "index_endpoints_on_added_by_id"
    t.index ["endpoint_group_id"], name: "index_endpoints_on_endpoint_group_id"
    t.index ["modified_by_id"], name: "index_endpoints_on_modified_by_id"
  end

  create_table "network_device_groups", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "network_devices", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "description"
    t.string "ip_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "mac"
    t.string "ip_address"
    t.string "username"
    t.string "audit_session_id"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["audit_session_id"], name: "index_sessions_on_audit_session_id"
    t.index ["ip_address"], name: "index_sessions_on_ip_address"
    t.index ["mac"], name: "index_sessions_on_mac"
    t.index ["username"], name: "index_sessions_on_username"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "endpoints", "users", column: "added_by_id"
  add_foreign_key "endpoints", "users", column: "modified_by_id"
end
