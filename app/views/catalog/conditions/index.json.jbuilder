# frozen_string_literal: true

json.array! @catalog_conditions, partial: "catalog/conditions/catalog_condition", as: :catalog_condition
