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

ActiveRecord::Schema[8.1].define(version: 2026_07_20_022255) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "copyright_alias_findings", force: :cascade do |t|
    t.integer "author_research_id", null: false
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.string "name"
    t.string "note"
    t.datetime "updated_at", null: false
    t.index ["author_research_id"], name: "index_copyright_alias_findings_on_author_research_id"
  end

  create_table "copyright_author_researches", force: :cascade do |t|
    t.integer "agent_id"
    t.text "basis"
    t.string "birth_date"
    t.datetime "created_at", null: false
    t.string "death_date"
    t.text "heirs"
    t.integer "investigation_id", null: false
    t.string "name"
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.string "us_status", null: false
    t.index ["agent_id"], name: "index_copyright_author_researches_on_agent_id"
    t.index ["investigation_id"], name: "index_copyright_author_researches_on_investigation_id"
  end

  create_table "copyright_citations", force: :cascade do |t|
    t.date "accessed_on"
    t.integer "citable_id", null: false
    t.string "citable_type", null: false
    t.datetime "created_at", null: false
    t.text "quote"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["citable_type", "citable_id"], name: "index_copyright_citations_on_citable"
  end

  create_table "copyright_clearance_authors", force: :cascade do |t|
    t.integer "clearance_id", null: false
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "position"
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index ["clearance_id"], name: "index_copyright_clearance_authors_on_clearance_id"
  end

  create_table "copyright_clearance_publishings", force: :cascade do |t|
    t.integer "clearance_id", null: false
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.string "year"
    t.index ["clearance_id"], name: "index_copyright_clearance_publishings_on_clearance_id"
  end

  create_table "copyright_clearances", force: :cascade do |t|
    t.datetime "cleared_at"
    t.datetime "created_at", null: false
    t.integer "determination_id"
    t.string "language_code"
    t.integer "manifestation_id", null: false
    t.text "notes"
    t.string "pg_ok_key"
    t.string "pg_request_id"
    t.string "pg_rule_applied"
    t.string "publication_city"
    t.string "publication_country"
    t.string "publisher_name"
    t.integer "researcher_id", null: false
    t.text "scans_archive_urls"
    t.text "source_notes"
    t.string "status", null: false
    t.datetime "submitted_at"
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.text "wikipedia_urls"
    t.index ["determination_id"], name: "index_copyright_clearances_on_determination_id"
    t.index ["manifestation_id"], name: "index_copyright_clearances_on_manifestation_id"
    t.index ["researcher_id"], name: "index_copyright_clearances_on_researcher_id"
  end

  create_table "copyright_copyright_claims", force: :cascade do |t|
    t.text "basis"
    t.string "claimant_name"
    t.datetime "created_at", null: false
    t.integer "investigation_id", null: false
    t.datetime "updated_at", null: false
    t.index ["investigation_id"], name: "index_copyright_copyright_claims_on_investigation_id"
  end

  create_table "copyright_determinations", force: :cascade do |t|
    t.string "basis"
    t.datetime "created_at", null: false
    t.string "first_publication_country"
    t.string "first_publication_year"
    t.string "initial_registration_number"
    t.integer "manifestation_id"
    t.text "notes"
    t.date "public_domain_on"
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["manifestation_id"], name: "index_copyright_determinations_on_manifestation_id"
    t.index ["work_id", "manifestation_id"], name: "index_copyright_determinations_uniqueness", unique: true
    t.index ["work_id"], name: "index_copyright_determinations_on_work_id"
    t.index ["work_id"], name: "index_copyright_determinations_unscoped_uniqueness", unique: true, where: "manifestation_id IS NULL"
  end

  create_table "copyright_findings", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.integer "investigation_id", null: false
    t.integer "position"
    t.string "question"
    t.string "section", null: false
    t.datetime "updated_at", null: false
    t.index ["investigation_id"], name: "index_copyright_findings_on_investigation_id"
  end

  create_table "copyright_investigations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "determination_id", null: false
    t.integer "researcher_id", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["determination_id"], name: "index_copyright_investigations_on_determination_id"
    t.index ["researcher_id"], name: "index_copyright_investigations_on_researcher_id"
  end

  create_table "copyright_renewal_records", force: :cascade do |t|
    t.boolean "applies"
    t.text "assessment"
    t.datetime "created_at", null: false
    t.string "holder"
    t.string "registration_number"
    t.string "renewal_number"
    t.integer "renewal_search_id", null: false
    t.datetime "updated_at", null: false
    t.index ["renewal_search_id"], name: "index_copyright_renewal_records_on_renewal_search_id"
  end

  create_table "copyright_renewal_searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "investigation_id", null: false
    t.text "outcome"
    t.string "resource"
    t.date "searched_on"
    t.string "status", null: false
    t.string "terms"
    t.datetime "updated_at", null: false
    t.index ["investigation_id"], name: "index_copyright_renewal_searches_on_investigation_id"
  end

  create_table "copyright_republications", force: :cascade do |t|
    t.string "access_status"
    t.datetime "created_at", null: false
    t.string "edition_designation"
    t.integer "investigation_id", null: false
    t.text "notes"
    t.string "publisher"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "year"
    t.index ["investigation_id"], name: "index_copyright_republications_on_investigation_id"
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

  create_table "workflow_projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "edition_manifestation_id"
    t.integer "lead_id", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["edition_manifestation_id"], name: "index_workflow_projects_on_edition_manifestation_id"
    t.index ["lead_id"], name: "index_workflow_projects_on_lead_id"
    t.index ["work_id"], name: "index_workflow_projects_on_work_id", unique: true
  end

  create_table "workflow_resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.string "note"
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["project_id", "kind"], name: "index_workflow_resources_text_repo_uniqueness", unique: true, where: "kind = 'text_repo'"
    t.index ["project_id"], name: "index_workflow_resources_on_project_id"
  end

  create_table "workflow_steps", force: :cascade do |t|
    t.integer "actor_id"
    t.datetime "created_at", null: false
    t.date "happened_on"
    t.string "kind", null: false
    t.text "note"
    t.integer "project_id", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_workflow_steps_on_actor_id"
    t.index ["project_id", "kind"], name: "index_workflow_steps_on_project_id_and_kind", unique: true
    t.index ["project_id"], name: "index_workflow_steps_on_project_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
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
  add_foreign_key "copyright_alias_findings", "copyright_author_researches", column: "author_research_id"
  add_foreign_key "copyright_author_researches", "catalog_agents", column: "agent_id"
  add_foreign_key "copyright_author_researches", "copyright_investigations", column: "investigation_id"
  add_foreign_key "copyright_clearance_authors", "copyright_clearances", column: "clearance_id"
  add_foreign_key "copyright_clearance_publishings", "copyright_clearances", column: "clearance_id"
  add_foreign_key "copyright_clearances", "catalog_manifestations", column: "manifestation_id"
  add_foreign_key "copyright_clearances", "copyright_determinations", column: "determination_id"
  add_foreign_key "copyright_clearances", "users", column: "researcher_id"
  add_foreign_key "copyright_copyright_claims", "copyright_investigations", column: "investigation_id"
  add_foreign_key "copyright_determinations", "catalog_manifestations", column: "manifestation_id"
  add_foreign_key "copyright_determinations", "catalog_works", column: "work_id"
  add_foreign_key "copyright_findings", "copyright_investigations", column: "investigation_id"
  add_foreign_key "copyright_investigations", "copyright_determinations", column: "determination_id"
  add_foreign_key "copyright_investigations", "users", column: "researcher_id"
  add_foreign_key "copyright_renewal_records", "copyright_renewal_searches", column: "renewal_search_id"
  add_foreign_key "copyright_renewal_searches", "copyright_investigations", column: "investigation_id"
  add_foreign_key "copyright_republications", "copyright_investigations", column: "investigation_id"
  add_foreign_key "roles", "users"
  add_foreign_key "roles", "users", column: "granted_by_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "workflow_projects", "catalog_manifestations", column: "edition_manifestation_id"
  add_foreign_key "workflow_projects", "catalog_works", column: "work_id"
  add_foreign_key "workflow_projects", "users", column: "lead_id"
  add_foreign_key "workflow_resources", "workflow_projects", column: "project_id"
  add_foreign_key "workflow_steps", "users", column: "actor_id"
  add_foreign_key "workflow_steps", "workflow_projects", column: "project_id"
end
