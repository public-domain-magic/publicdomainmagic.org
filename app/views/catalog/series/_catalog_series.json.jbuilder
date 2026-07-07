# frozen_string_literal: true

json.extract! catalog_series, :id, :name, :created_at, :updated_at
json.url catalog_series_url(catalog_series, format: :json)
