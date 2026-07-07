# frozen_string_literal: true

json.array! @catalog_expressions, partial: "catalog/expressions/catalog_expression", as: :catalog_expression
