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

ActiveRecord::Schema[8.1].define(version: 2026_06_06_023055) do
  create_table "catalog_conditions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_expressions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
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
    t.string "code", limit: 2
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_catalog_languages_on_code", unique: true
  end

  create_table "catalog_manifestations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_publication"
    t.string "edition_or_issue"
    t.integer "expression_id", null: false
    t.integer "form_of_expression_id", null: false
    t.integer "language_id", null: false
    t.integer "medium_id", null: false
    t.integer "series_id", null: false
    t.string "statement_of_responsibility"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["expression_id"], name: "index_catalog_manifestations_on_expression_id"
    t.index ["form_of_expression_id"], name: "index_catalog_manifestations_on_form_of_expression_id"
    t.index ["language_id"], name: "index_catalog_manifestations_on_language_id"
    t.index ["medium_id"], name: "index_catalog_manifestations_on_medium_id"
    t.index ["series_id"], name: "index_catalog_manifestations_on_series_id"
  end

  create_table "catalog_media", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_series", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "catalog_works", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "form_of_work_id", null: false
    t.string "identifier"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["form_of_work_id"], name: "index_catalog_works_on_form_of_work_id"
  end

  create_table "intended_audiences_works", id: false, force: :cascade do |t|
    t.integer "intended_audience_id", null: false
    t.integer "work_id", null: false
    t.index ["intended_audience_id", "work_id"], name: "idx_on_intended_audience_id_work_id_9d1b9470f5"
    t.index ["work_id", "intended_audience_id"], name: "idx_on_work_id_intended_audience_id_91ee403c01"
  end

  add_foreign_key "catalog_expressions", "form_of_expressions"
  add_foreign_key "catalog_expressions", "languages"
  add_foreign_key "catalog_expressions", "works"
  add_foreign_key "catalog_items", "conditions"
  add_foreign_key "catalog_items", "manifestations"
  add_foreign_key "catalog_manifestations", "expressions"
  add_foreign_key "catalog_manifestations", "form_of_expressions"
  add_foreign_key "catalog_manifestations", "languages"
  add_foreign_key "catalog_manifestations", "media"
  add_foreign_key "catalog_manifestations", "series"
  add_foreign_key "catalog_works", "form_of_works"
end
