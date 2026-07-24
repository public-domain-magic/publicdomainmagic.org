# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# An external reference to one of *our own* production artifacts, tracked
# instead of stored: scan sets are ~80 GB (they live on Internet Archive) and
# each book's text is its own git repository, so the app keeps URLs, never
# bytes. Where a book otherwise exists online — third-party scans, transcripts,
# publisher ebooks — is not our production; those are Catalog editions (digital
# manifestations bearing an access address), not Workflow resources.
class Workflow::Resource < ApplicationRecord
  # Where the reference points, our-artifacts-only. +ia_scan_set+ is the scan
  # set we uploaded to Internet Archive; +text_repo+ is the book's git
  # repository locator — an opaque string (it may be an SSH clone URL, not
  # necessarily https), unique per project; +pdm_ebook+ the final downloadable
  # edition we publish; +other+ a catch-all (e.g. a dealer listing for a copy
  # we are acquiring).
  KINDS = %w[
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
