# frozen_string_literal: true

json.array! @catalog_series, partial: "catalog/series/catalog_series", as: :catalog_series
