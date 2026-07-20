# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One row of a project's ledger: a fixed kind of work, independently
# todo/in_progress/done/skipped, with the actor who did it and when. The
# ledger replaces a linear state machine — steps are advisory and the owner
# iterates out of order, so nothing here enforces sequence.
class Workflow::Step < ApplicationRecord
  # The fixed ledger, one row per kind per project. +copyright_clearance+
  # mirrors the Copyright context's outcome; +text_pipeline+ is the whole
  # PG→Standard-Ebooks conversion as ONE step (done ⇒ downloadable); the
  # print steps default to skipped for non-applicable books (budget softcover
  # only for public-exposure titles — that classification is Magic's).
  KINDS = %w[
    discovery
    bibliographic_research
    source_survey
    copyright_clearance
    scans
    transcription
    text_pipeline
    publication
    print_collectible
    print_budget
  ].freeze

  # Where the step stands. +skipped+ marks a step that will never apply to
  # this book, as opposed to one not yet reached.
  STATUSES = %w[todo in_progress done skipped].freeze

  belongs_to :project
  belongs_to :actor, class_name: "User", optional: true

  enum :kind, KINDS.index_by(&:itself), validate: true
  enum :status, STATUSES.index_by(&:itself), validate: true

  validates :kind, uniqueness: { scope: :project_id }
end
