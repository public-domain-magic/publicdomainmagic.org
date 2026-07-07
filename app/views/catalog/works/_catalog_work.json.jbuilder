# frozen_string_literal: true

json.extract! catalog_work, :id, :title, :date, :identifier, :form_of_work_id, :created_at, :updated_at
json.url catalog_work_url(catalog_work, format: :json)
