# frozen_string_literal: true

json.array! @catalog_languages, partial: "catalog/languages/catalog_language", as: :catalog_language
