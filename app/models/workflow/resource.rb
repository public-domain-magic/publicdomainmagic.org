# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# An external reference a project tracks instead of storing the artifact:
# scan sets are ~80 GB (they live on Internet Archive) and each book's text
# is its own git repository, so the app keeps URLs, never bytes.
class Workflow::Resource < ApplicationRecord
  # Where the reference points. +text_repo+ is the book's git repository
  # locator — an opaque string (it may be an SSH clone URL, not necessarily
  # https), unique per project; +ia_scan_set+ is the uploaded scan set;
  # +pg_ebook+ the published Gutenberg ebook; +pdm_ebook+ the final
  # downloadable edition.
  KINDS = %w[
    hathitrust_scans
    archive_scans
    google_books_scans
    pg_transcript
    pg_ebook
    ia_scan_set
    text_repo
    pdm_ebook
    other
  ].freeze

  belongs_to :project

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :url, presence: true
  validates :kind, uniqueness: { scope: :project_id }, if: :text_repo?
end
