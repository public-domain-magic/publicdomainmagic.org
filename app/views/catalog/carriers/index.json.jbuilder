# frozen_string_literal: true

json.array! @catalog_carriers, partial: "catalog/carriers/catalog_carrier", as: :catalog_carrier
