json.extract! catalog_item, :id, :identifier, :provenance, :marks, :manifestation_id, :condition_id, :created_at, :updated_at
json.url catalog_item_url(catalog_item, format: :json)
