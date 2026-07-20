# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::ClearanceTest < ActiveSupport::TestCase
  test "the golden clearance round-trips" do
    clearance = copyright_clearances(:royal_road)
    assert_predicate clearance, :valid?
    assert_predicate clearance, :cleared?
    assert_equal "87848", clearance.pg_request_id
    assert_equal "OK: Rule 6", clearance.pg_rule_applied
    assert_equal "20250510173922hugard", clearance.pg_ok_key
    assert_equal catalog_manifestations(:world_1951), clearance.manifestation
    assert_equal users(:kerrick), clearance.researcher
  end

  test "authors are ordered by form position" do
    assert_equal %w[Hugard Braué Fleming Rigney],
      copyright_clearances(:royal_road).authors.map(&:last_name)
  end

  test "status must be in the vocabulary" do
    clearance = copyright_clearances(:royal_road)
    clearance.status = "approved"
    assert_not clearance.valid?
    assert clearance.errors.of_kind?(:status, :inclusion)
  end

  test "form fields are capped at PG's database capacities" do
    clearance = copyright_clearances(:royal_road)
    clearance.assign_attributes(
      title: "a" * 601, subtitle: "a" * 601, language_code: "eng",
      notes: "a" * 6001, source_notes: "a" * 6001, publisher_name: "a" * 241,
      publication_city: "a" * 61, publication_country: "a" * 31,
      scans_archive_urls: "a" * 1601, wikipedia_urls: "a" * 1601)
    assert_not clearance.valid?
    %i[
      title
      subtitle
      language_code
      notes
      source_notes
      publisher_name
      publication_city
      publication_country
      scans_archive_urls
      wikipedia_urls
].each do |field|
      assert clearance.errors.of_kind?(field, :too_long), "expected #{field} to be too long"
    end
  end

  test "at most five authors fit the PG form" do
    clearance = copyright_clearances(:royal_road)
    2.times { |i| clearance.authors.build(first_name: "Extra", last_name: "Author #{i}", role: :contributor) }
    assert_not clearance.valid?
    assert_includes clearance.errors[:authors], "cannot exceed 5 (the PG form limit)"
  end

  test "at most four publishings fit the PG form" do
    clearance = copyright_clearances(:royal_road)
    3.times { |i| clearance.publishings.build(year: (1952 + i).to_s, kind: :reprint_or_facsimile) }
    assert_not clearance.valid?
    assert_includes clearance.errors[:publishings], "cannot exceed 4 (the PG form limit)"
  end

  test "at most four page scans fit the PG form" do
    clearance = copyright_clearances(:royal_road)
    5.times { |i| clearance.page_scans.attach(blob_for("scan#{i}.png", byte_size: 1_000)) }
    assert_not clearance.valid?
    assert_includes clearance.errors[:page_scans], "cannot exceed 4 (the PG form limit)"
  end

  test "page scans must be JPG, GIF, PNG, or TXT" do
    clearance = copyright_clearances(:royal_road)
    clearance.page_scans.attach(blob_for("scan.pdf", content_type: "application/pdf"))
    assert_not clearance.valid?
    assert_includes clearance.errors[:page_scans], "scan.pdf must be a JPG, GIF, PNG, or TXT file"
  end

  test "page scans must fit PG's upload size limit" do
    clearance = copyright_clearances(:royal_road)
    clearance.page_scans.attach(blob_for("verso.png", byte_size: 5_000_001))
    assert_not clearance.valid?
    assert_includes clearance.errors[:page_scans], "verso.png must be 5 MB or smaller (the PG upload limit)"
  end

  test "four conforming page scans are valid" do
    clearance = copyright_clearances(:royal_road)
    clearance.page_scans.attach(blob_for("title.png", byte_size: 4_999_999))
    clearance.page_scans.attach(blob_for("verso.txt", content_type: "text/plain"))
    assert_predicate clearance, :valid?
  end

  test "determination is optional" do
    clearance = copyright_clearances(:royal_road)
    clearance.determination = nil
    assert_predicate clearance, :valid?
  end

  # A blob with metadata but no uploaded bytes: these tests validate form
  # limits, never file contents, so no IO is needed. Marked identified and
  # analyzed so attaching skips the download-based identification pass.
  private def blob_for(filename, content_type: "image/png", byte_size: 1_000)
    ActiveStorage::Blob.create!(
      key: ActiveStorage::Blob.generate_unique_secure_token,
      filename:, content_type:, byte_size:, checksum: "unused",
      metadata: { identified: true, analyzed: true })
  end
end
