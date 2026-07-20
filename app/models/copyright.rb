# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The Copyright bounded context: answers "what is this work's US copyright
# status, and how do we prove it?" It speaks the language of 17 U.S.C. and the
# U.S. Copyright Office (work of authorship, publication, registration,
# renewal, claimant, term); Project Gutenberg's operational layer (rule
# numbers, "clearance", OK keys) is an integration seam confined to the
# PG-facing exchange objects. Its tables share the +copyright_+ prefix so the
# context owns a distinct slice of the schema. It references Catalog by ID and
# writes nothing to Catalog.
module Copyright
  # Namespaces every Copyright model's table with +copyright_+, keeping the
  # context's tables grouped and free of collisions with other contexts.
  def self.table_name_prefix
    "copyright_"
  end
end
