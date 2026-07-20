# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The Magic bounded context: the public-facing domain — search and browse of
# the library, the access rules for downloads, and the commerce hooks
# (purchase links, countdown hype). PDM is a library, not a trick index, so
# launch models the book level with flat tags for classification. Its tables
# share the +magic_+ prefix so the context owns a distinct slice of the
# schema. It references Catalog by ID and adds no bibliographic data of its
# own.
module Magic
  # Namespaces every Magic model's table with +magic_+, keeping the
  # context's tables grouped and free of collisions with other contexts.
  def self.table_name_prefix
    "magic_"
  end
end
