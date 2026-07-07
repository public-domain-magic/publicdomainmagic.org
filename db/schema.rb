# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_06_141104) do
  create_table "catalog_agents", force: :cascade do |t|
    t.string "birth_date"
    t.datetime "created_at", null: false
    t.string "death_date"
    t.string "kind", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalog_carriers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_concepts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_catalog_concepts_on_name", unique: true
  end

  create_table "catalog_conditions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_contributions", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.integer "contributable_id", null: false
    t.string "contributable_type", null: false
    t.datetime "created_at", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_catalog_contributions_on_agent_id"
    t.index ["contributable_type", "contributable_id"], name: "index_catalog_contributions_on_contributable"
  end

  create_table "catalog_embodiments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "expression_id", null: false
    t.integer "manifestation_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["expression_id"], name: "index_catalog_embodiments_on_expression_id"
    t.index ["manifestation_id", "expression_id"], name: "index_catalog_embodiments_uniqueness", unique: true
    t.index ["manifestation_id"], name: "index_catalog_embodiments_on_manifestation_id"
  end

  create_table "catalog_expression_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "expression_id", null: false
    t.string "kind", null: false
    t.integer "related_expression_id", null: false
    t.datetime "updated_at", null: false
    t.index ["expression_id", "related_expression_id", "kind"], name: "index_catalog_expression_relationships_uniqueness", unique: true
    t.index ["expression_id"], name: "index_catalog_expression_relationships_on_expression_id"
    t.index ["related_expression_id"], name: "index_catalog_expr_relationships_on_related_expression_id"
  end

  create_table "catalog_expressions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "date"
    t.integer "form_of_expression_id", null: false
    t.string "identifier"
    t.integer "language_id", null: false
    t.string "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["form_of_expression_id"], name: "index_catalog_expressions_on_form_of_expression_id"
    t.index ["language_id"], name: "index_catalog_expressions_on_language_id"
    t.index ["work_id"], name: "index_catalog_expressions_on_work_id"
  end

  create_table "catalog_form_of_expressions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_form_of_works", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_intended_audiences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_intended_audiences_works", id: false, force: :cascade do |t|
    t.integer "intended_audience_id", null: false
    t.integer "work_id", null: false
    t.index ["intended_audience_id", "work_id"], name: "idx_on_intended_audience_id_work_id_01f990f0c6"
    t.index ["work_id", "intended_audience_id"], name: "idx_on_work_id_intended_audience_id_1452392be6"
  end

  create_table "catalog_items", force: :cascade do |t|
    t.integer "condition_id", null: false
    t.datetime "created_at", null: false
    t.string "identifier"
    t.integer "manifestation_id", null: false
    t.string "marks"
    t.string "provenance"
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_catalog_items_on_condition_id"
    t.index ["manifestation_id"], name: "index_catalog_items_on_manifestation_id"
  end

  create_table "catalog_languages", force: :cascade do |t|
    t.string "code", limit: 3
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_catalog_languages_on_code", unique: true
  end

  create_table "catalog_manifestation_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.integer "manifestation_id", null: false
    t.integer "related_manifestation_id", null: false
    t.datetime "updated_at", null: false
    t.index ["manifestation_id", "related_manifestation_id", "kind"], name: "index_catalog_manifestation_relationships_uniqueness", unique: true
    t.index ["manifestation_id"], name: "index_catalog_manif_relationships_on_manifestation_id"
    t.index ["related_manifestation_id"], name: "index_catalog_manif_relationships_on_related_manif_id"
  end

  create_table "catalog_manifestations", force: :cascade do |t|
    t.integer "carrier_id", null: false
    t.datetime "created_at", null: false
    t.date "date_of_publication"
    t.string "edition_or_issue"
    t.string "identifier"
    t.string "place_of_publication"
    t.integer "series_id"
    t.string "statement_of_responsibility"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_catalog_manifestations_on_carrier_id"
    t.index ["series_id"], name: "index_catalog_manifestations_on_series_id"
  end

  create_table "catalog_nomens", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.string "name", null: false
    t.string "note"
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_catalog_nomens_on_agent_id"
  end

  create_table "catalog_series", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_subjects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "subject_id", null: false
    t.string "subject_type", null: false
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["subject_type", "subject_id"], name: "index_catalog_subjects_on_subject"
    t.index ["work_id", "subject_type", "subject_id"], name: "index_catalog_subjects_uniqueness", unique: true
    t.index ["work_id"], name: "index_catalog_subjects_on_work_id"
  end

  create_table "catalog_work_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.integer "related_work_id", null: false
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["related_work_id"], name: "index_catalog_work_relationships_on_related_work_id"
    t.index ["work_id", "related_work_id", "kind"], name: "index_catalog_work_relationships_uniqueness", unique: true
    t.index ["work_id"], name: "index_catalog_work_relationships_on_work_id"
  end

  create_table "catalog_works", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "date"
    t.integer "form_of_work_id", null: false
    t.string "identifier"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["form_of_work_id"], name: "index_catalog_works_on_form_of_work_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "granted_by_id"
    t.string "name", null: false
    t.string "note"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["granted_by_id"], name: "index_roles_on_granted_by_id"
    t.index ["user_id", "name"], name: "index_roles_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "catalog_contributions", "catalog_agents", column: "agent_id"
  add_foreign_key "catalog_embodiments", "catalog_expressions", column: "expression_id"
  add_foreign_key "catalog_embodiments", "catalog_manifestations", column: "manifestation_id"
  add_foreign_key "catalog_expression_relationships", "catalog_expressions", column: "expression_id"
  add_foreign_key "catalog_expression_relationships", "catalog_expressions", column: "related_expression_id"
  add_foreign_key "catalog_expressions", "catalog_form_of_expressions", column: "form_of_expression_id"
  add_foreign_key "catalog_expressions", "catalog_languages", column: "language_id"
  add_foreign_key "catalog_expressions", "catalog_works", column: "work_id"
  add_foreign_key "catalog_items", "catalog_conditions", column: "condition_id"
  add_foreign_key "catalog_items", "catalog_manifestations", column: "manifestation_id"
  add_foreign_key "catalog_manifestation_relationships", "catalog_manifestations", column: "manifestation_id"
  add_foreign_key "catalog_manifestation_relationships", "catalog_manifestations", column: "related_manifestation_id"
  add_foreign_key "catalog_manifestations", "catalog_carriers", column: "carrier_id"
  add_foreign_key "catalog_manifestations", "catalog_series", column: "series_id"
  add_foreign_key "catalog_nomens", "catalog_agents", column: "agent_id"
  add_foreign_key "catalog_subjects", "catalog_works", column: "work_id"
  add_foreign_key "catalog_work_relationships", "catalog_works", column: "related_work_id"
  add_foreign_key "catalog_work_relationships", "catalog_works", column: "work_id"
  add_foreign_key "catalog_works", "catalog_form_of_works", column: "form_of_work_id"
  add_foreign_key "roles", "users"
  add_foreign_key "roles", "users", column: "granted_by_id"
  add_foreign_key "sessions", "users"
end
