# frozen_string_literal: true

json.array! @catalog_works, partial: "catalog/works/catalog_work", as: :catalog_work
