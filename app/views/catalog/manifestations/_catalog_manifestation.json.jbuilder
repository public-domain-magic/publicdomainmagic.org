json.extract! catalog_manifestation, :id, :title, :statement_of_responsibility, :edition_or_issue, :date_of_publication, :place_of_publication, :identifier, :carrier_id, :series_id, :created_at, :updated_at
json.url catalog_manifestation_url(catalog_manifestation, format: :json)
