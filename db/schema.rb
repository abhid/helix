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

ActiveRecord::Schema.define(version: 2019_10_25_031127) do

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
    t.macaddr "mac"
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

  create_table "network_device_groups_devices", force: :cascade do |t|
    t.bigint "network_device_id"
    t.bigint "network_device_group_id"
    t.index ["network_device_group_id"], name: "index_network_device_groups_devices_on_network_device_group_id"
    t.index ["network_device_id"], name: "index_network_device_groups_devices_on_network_device_id"
  end

  create_table "network_devices", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "description"
    t.string "type"
    t.string "ip_address"
    t.boolean "updated", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ouis", force: :cascade do |t|
    t.macaddr "oui"
    t.string "vendor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["oui"], name: "index_ouis_on_oui"
    t.index ["vendor"], name: "index_ouis_on_vendor"
  end

  create_table "sessions", force: :cascade do |t|
    t.macaddr "mac"
    t.string "mac_text"
    t.string "ip_address"
    t.string "username"
    t.string "audit_session_id"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["audit_session_id"], name: "index_sessions_on_audit_session_id"
    t.index ["ip_address"], name: "index_sessions_on_ip_address"
    t.index ["mac"], name: "index_sessions_on_mac"
    t.index ["mac_text"], name: "index_sessions_on_mac_text"
    t.index ["username"], name: "index_sessions_on_username"
  end

  create_table "settings", force: :cascade do |t|
    t.string "namespace"
    t.json "hash"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.inet "last_login_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "endpoints", "users", column: "added_by_id"
  add_foreign_key "endpoints", "users", column: "modified_by_id"
end
