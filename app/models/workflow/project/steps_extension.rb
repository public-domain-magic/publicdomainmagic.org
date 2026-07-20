# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The ledger's write API, mixed into a project's steps association: callers
# address steps by kind and say what happened — they never assemble status
# hashes at call sites.
module Workflow::Project::StepsExtension
  # The step of the given kind — every project has exactly one per kind.
  def [](kind) = find_by!(kind:)

  # Marks the step of the given kind done, recording the actor, the date,
  # and an optional note, and returns the step. Completing an already-done
  # step just re-records.
  def complete(kind, by: Current.user, note: nil)
    self[kind].update!(status: :done, actor: by, happened_on: Date.current, note:)
  end
end
