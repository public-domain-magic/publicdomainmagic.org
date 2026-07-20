# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::Investigation::ReportTest < ActiveSupport::TestCase
  setup do
    @complete = copyright_investigations(:royal_road).report.to_markdown
    @in_progress = copyright_investigations(:trick_brain).report.to_markdown
  end

  test "renders the questionnaire's phase headings" do
    [
      "# Rule 6 Research",
      "# Basic Information",
      "# Phase 1: Biographical Research",
      "# Phase 2: Bibliographical Research",
      "# Phase 3: Renewal Research",
].each do |heading|
      assert_includes @complete, heading
      assert_includes @in_progress, heading
    end
  end

  test "renders basic information from the determination" do
    assert_includes @complete, "The Royal Road to Card Magic"
    assert_includes @complete, "A20124"
    assert_includes @in_progress, "A 184118"
  end

  test "renders each author research with role, status, and vital dates" do
    assert_includes @complete, "## Jean Hugard, Author/Creator"
    assert_includes @complete, "## Frank Rigney, Illustrator"
    assert_includes @complete,
      "Jean Hugard was a domiciliary of the United States at the time of publication."
    assert_includes @complete, "Born 1871-12-04. Died 1959-08-14."
    assert_includes @in_progress,
      "Dariel Fitzkee was a national of the United States at the time of publication."
  end

  test "renders aliases with their citations" do
    assert_includes @complete,
      "* **John Gerard Rodney Boyce**, birth name. Source: <https://enterthroughthelaundry.com/jean-hugard>."
    assert_includes @complete, "* **Ching Ling Foo**, performance name."
    assert_includes @in_progress, "* **Dariel Fitzroy**, legal name."
  end

  test "renders heirs" do
    assert_includes @complete, "Heirs or other parties who might have had the right to renew:"
    assert_includes @complete, "Margaret Annie Griffiths"
  end

  test "renders third-party copyright claims" do
    assert_includes @in_progress, "## Third-Party Copyright Claims"
    assert_includes @in_progress,
      "Magic Box Productions: Claimed \"Full permission granted us from Lee Jacobs Productions\""
  end

  test "renders republications with access caveats" do
    assert_includes @complete,
      "* The Royal Road to Card Magic, 1951, The World Publishing Company (examined)"
    assert_includes @in_progress, "Third Printing (inaccessible)"
    assert_includes @in_progress, "out of my reach, because of its rarity"
  end

  test "renders the renewal search matrix with outcome markers" do
    assert_includes @complete, "* ✅ Stanford Copyright Renewals — “Hugard” (searched 2025-05-01)"
    assert_includes @complete, "* ‼️ Stanford Copyright Renewals — “Benson, Myra”"
    assert_includes @in_progress, "* 🔲 Stanford Copyright Renewals — “Fitzkee”"
  end

  test "renders found renewal records even when they do not apply" do
    assert_includes @complete, "Renewal R410430, held by Myra C. Benson."
    assert_includes @complete, "This renewal does not apply to the work under investigation."
    assert_includes @complete, "Source: <https://exhibits.stanford.edu/copyrightrenewals/catalog/R410430>."
  end

  test "renders negative findings verbatim in their section" do
    assert_includes @complete, "## Was the item part of a serial (i.e., in a magazine)?"
    assert_includes @complete, "I found no evidence that it was part of a serial."
  end
end
