# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One Project Gutenberg copyright clearance request lifecycle for the actual
# book being digitized (PG's own rule: research the actual copy, not other
# editions), so it anchors to a Catalog manifestation.
#
# This is a PG-facing exchange object: its columns mirror the copy.pglaf.org
# submission form, with length validations matching PG's database capacities
# (PG silently truncates; we validate instead). The form-mirror fields are
# deliberate snapshots, not live joins to Catalog — the submission must record
# what was sent, even if Catalog data is later corrected.
class Copyright::Clearance < ApplicationRecord
  # PG's form accepts at most five authors (+in_author1+ … +in_author5+).
  MAX_AUTHORS = 5

  # PG's form accepts at most four publishings (+in_pubyear1+ … +in_pubyear4+).
  MAX_PUBLISHINGS = 4

  # PG's form accepts at most four page scans (+upfile1+ … +upfile4+).
  MAX_PAGE_SCANS = 4

  # The file types PG's upload form accepts for page scans.
  PAGE_SCAN_CONTENT_TYPES = %w[image/jpeg image/gif image/png text/plain].freeze

  # PG's prose says 10 MB per scan, but the form's hidden +MAX_FILE_SIZE+ is
  # 5,000,000 — validate against the form so the immediate-upload path works.
  PAGE_SCAN_MAX_BYTES = 5_000_000

  # Where the request stands with PG. +iterating+ covers PG follow-up
  # questions after submission; +withdrawn+ is ours, not PG's — no dead ends.
  STATUSES = %w[drafting submitted iterating cleared withdrawn].freeze

  belongs_to :manifestation, class_name: "Catalog::Manifestation"
  belongs_to :determination, optional: true
  belongs_to :researcher, class_name: "User"

  has_many :authors, -> { order(:position) },
    class_name: "Copyright::ClearanceAuthor", inverse_of: :clearance, dependent: :destroy
  has_many :publishings, -> { order(:position) },
    class_name: "Copyright::ClearancePublishing", inverse_of: :clearance, dependent: :destroy
  has_many_attached :page_scans

  enum :status, STATUSES.index_by(&:itself), validate: true

  validates :title, :subtitle, length: { maximum: 600 }
  validates :language_code, length: { maximum: 2 }
  validates :notes, :source_notes, length: { maximum: 6000 }
  validates :publisher_name, length: { maximum: 240 }
  validates :publication_city, length: { maximum: 60 }
  validates :publication_country, length: { maximum: 30 }
  validates :scans_archive_urls, :wikipedia_urls, length: { maximum: 1600 }

  validate :authors_fit_pg_form
  validate :publishings_fit_pg_form
  validate :page_scans_fit_pg_form

  private def authors_fit_pg_form
    errors.add(:authors, "cannot exceed #{MAX_AUTHORS} (the PG form limit)") if authors.size > MAX_AUTHORS
  end

  private def publishings_fit_pg_form
    if publishings.size > MAX_PUBLISHINGS
      errors.add(:publishings, "cannot exceed #{MAX_PUBLISHINGS} (the PG form limit)")
    end
  end

  private def page_scans_fit_pg_form
    if page_scans.attachments.size > MAX_PAGE_SCANS
      errors.add(:page_scans, "cannot exceed #{MAX_PAGE_SCANS} (the PG form limit)")
    end

    page_scans.blobs.each do |blob|
      unless blob.content_type.in?(PAGE_SCAN_CONTENT_TYPES)
        errors.add(:page_scans, "#{blob.filename} must be a JPG, GIF, PNG, or TXT file")
      end
      if blob.byte_size > PAGE_SCAN_MAX_BYTES
        errors.add(:page_scans, "#{blob.filename} must be 5 MB or smaller (the PG upload limit)")
      end
    end
  end
end
