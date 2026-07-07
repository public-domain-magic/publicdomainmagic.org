# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The Catalog bounded context: the FRBR/WEMI bibliographic model (Work,
# Expression, Manifestation, Item and their agents, relationships, and
# vocabularies). Its tables share the +catalog_+ prefix so the context owns a
# distinct slice of the schema.
module Catalog
  # Namespaces every Catalog model's table with +catalog_+, keeping the
  # context's tables grouped and free of collisions with other contexts.
  def self.table_name_prefix
    "catalog_"
  end
end
