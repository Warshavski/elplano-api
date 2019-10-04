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

ActiveRecord::Schema.define(version: 2019_10_04_104553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bug_reports", force: :cascade do |t|
    t.bigint "reporter_id", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "id"], name: "index_bug_reports_on_created_at_and_id"
    t.index ["reporter_id"], name: "index_bug_reports_on_reporter_id"
    t.index ["updated_at", "id"], name: "index_bug_reports_on_updated_at_and_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["active"], name: "index_courses_on_active", where: "(active = true)"
    t.index ["group_id", "title"], name: "index_courses_on_group_id_and_title", unique: true
    t.index ["group_id"], name: "index_courses_on_group_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.bigint "creator_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at"
    t.string "timezone", null: false
    t.jsonb "recurrence", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "confirmed", null: false
    t.bigint "course_id"
    t.string "eventable_type", null: false
    t.bigint "eventable_id", null: false
    t.string "foreground_color", limit: 7
    t.string "background_color", limit: 7
    t.index ["course_id"], name: "index_events_on_course_id"
    t.index ["creator_id"], name: "index_events_on_creator_id"
    t.index ["eventable_id", "eventable_type"], name: "index_events_on_eventable_id_and_eventable_type"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable_type_and_eventable_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "president_id", null: false
    t.string "number", limit: 25, null: false
    t.string "title", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["president_id"], name: "index_groups_on_president_id"
  end

  create_table "invites", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id"
    t.bigint "group_id", null: false
    t.string "email", null: false
    t.string "invitation_token"
    t.datetime "sent_at", null: false
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "email"], name: "index_invites_on_group_id_and_email", unique: true
    t.index ["group_id"], name: "index_invites_on_group_id"
    t.index ["invitation_token"], name: "index_invites_on_invitation_token", unique: true
    t.index ["recipient_id"], name: "index_invites_on_recipient_id"
    t.index ["sender_id"], name: "index_invites_on_sender_id"
  end

  create_table "lecturers", force: :cascade do |t|
    t.string "first_name", limit: 40, null: false
    t.string "last_name", limit: 40, null: false
    t.string "patronymic", limit: 40, null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "avatar_data"
    t.string "email"
    t.string "phone"
    t.boolean "active", default: true, null: false
    t.index ["active"], name: "index_lecturers_on_active", where: "(active = true)"
    t.index ["group_id", "first_name", "last_name", "patronymic"], name: "index_lecturers_on_full_name_and_group", unique: true
    t.index ["group_id"], name: "index_lecturers_on_group_id"
  end

  create_table "lectures", force: :cascade do |t|
    t.bigint "lecturer_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lectures_on_course_id"
    t.index ["lecturer_id", "course_id"], name: "index_lectures_on_lecturer_id_and_course_id", unique: true
    t.index ["lecturer_id"], name: "index_lectures_on_lecturer_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "full_name", limit: 200
    t.string "email", limit: 100
    t.string "phone", limit: 50
    t.text "about"
    t.jsonb "social_networks", default: {}, null: false
    t.boolean "president", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_students_on_group_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "avatar"
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "banned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["banned_at", "id"], name: "index_users_on_banned_at_and_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["confirmed_at", "id"], name: "index_users_on_confirmed_at_and_id"
    t.index ["created_at", "id"], name: "index_users_on_created_at_and_id"
    t.index ["email", "id"], name: "index_users_on_email_and_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["updated_at", "id"], name: "index_users_on_updated_at_and_id"
    t.index ["username", "id"], name: "index_users_on_username_and_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bug_reports", "users", column: "reporter_id"
  add_foreign_key "courses", "groups"
  add_foreign_key "events", "courses"
  add_foreign_key "events", "students", column: "creator_id"
  add_foreign_key "groups", "students", column: "president_id"
  add_foreign_key "invites", "groups"
  add_foreign_key "invites", "students", column: "recipient_id"
  add_foreign_key "invites", "students", column: "sender_id"
  add_foreign_key "lecturers", "groups"
  add_foreign_key "lectures", "courses"
  add_foreign_key "lectures", "lecturers"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "students", "groups"
  add_foreign_key "students", "users"
end
