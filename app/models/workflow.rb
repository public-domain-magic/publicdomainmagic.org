# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The Workflow bounded context: tracks a book's journey from discovery
# through copyright clearance, scanning, transcription, the text pipeline,
# and publication. Progress is a step ledger, not a status column — "failure
# isn't a thing, it's just how far it goes." Its tables share the +workflow_+
# prefix so the context owns a distinct slice of the schema. It references
# Catalog and Users by ID; big artifacts (scan sets, text repositories) live
# outside the app and are tracked as resource URLs.
module Workflow
  # Namespaces every Workflow model's table with +workflow_+, keeping the
  # context's tables grouped and free of collisions with other contexts.
  def self.table_name_prefix
    "workflow_"
  end
end
