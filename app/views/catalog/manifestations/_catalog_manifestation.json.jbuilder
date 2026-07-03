json.extract! catalog_manifestation, :id, :title, :statement_of_responsibility, :edition_or_issue, :date_of_publication, :form_of_expression_id, :medium_id, :language_id, :series_id, :expression_id, :created_at, :updated_at
json.url catalog_manifestation_url(catalog_manifestation, format: :json)
