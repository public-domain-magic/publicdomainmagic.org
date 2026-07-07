# frozen_string_literal: true

json.extract! catalog_expression, :id, :title, :date, :identifier, :summary, :form_of_expression_id, :language_id, :work_id, :created_at, :updated_at
json.url catalog_expression_url(catalog_expression, format: :json)
