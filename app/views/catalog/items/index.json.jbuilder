# frozen_string_literal: true

json.array! @catalog_items, partial: "catalog/items/catalog_item", as: :catalog_item
