# frozen_string_literal: true

json.array! @catalog_manifestations, partial: "catalog/manifestations/catalog_manifestation", as: :catalog_manifestation
