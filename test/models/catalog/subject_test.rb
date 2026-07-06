# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::SubjectTest < ActiveSupport::TestCase
  test "a concept can be the subject of a work" do
    assert_includes catalog_works(:royal_road).subjects.map(&:subject), catalog_concepts(:card_magic)
  end

  test "a work can be the subject of a work" do
    assert_equal catalog_works(:discoverie), catalog_subjects(:annals_about_discoverie).subject
  end

  test "work.concepts reads through subjects and only returns concepts" do
    assert_includes catalog_works(:discoverie).concepts, catalog_concepts(:cups_and_balls)
    assert_empty catalog_works(:annals).concepts
  end

  test "a subject is unique per work and subject type" do
    duplicate = Catalog::Subject.new(work: catalog_works(:royal_road), subject: catalog_concepts(:card_magic))
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:subject_id, :taken)
  end
end
